class JwtService
  ALGORITHM = 'HS256'
  DEFAULT_EXPIRATION = 24.hours

  class << self
    # Encode a payload into a JWT token
    def encode(payload, expiration: DEFAULT_EXPIRATION)
      payload = payload.dup
      payload[:exp] = expiration.from_now.to_i if expiration
      
      JWT.encode(payload, secret_key, ALGORITHM)
    end

    # Decode and verify a JWT token
    def decode(token)
      decoded = JWT.decode(
        token,
        secret_key,
        true,
        { algorithm: ALGORITHM, verify_expiration: true }
      )
      
      HashWithIndifferentAccess.new(decoded[0])
    rescue JWT::ExpiredSignature
      raise UnauthorizedError, I18n.t('api.errors.token_expired')
    rescue JWT::DecodeError => e
      raise UnauthorizedError, I18n.t('api.errors.invalid_token')
    end

    # Generate a token for a user
    def encode_user(user, expiration: DEFAULT_EXPIRATION)
      encode(
        {
          user_id: user.id,
          email: user.email,
          iat: Time.current.to_i
        },
        expiration: expiration
      )
    end

    # Decode and find user from token
    def decode_user(token)
      payload = decode(token)
      User.find(payload[:user_id])
    rescue ActiveRecord::RecordNotFound
      raise UnauthorizedError, I18n.t('api.errors.user_not_found')
    end

    private

    def secret_key
      @secret_key ||= ENV.fetch('JWT_SECRET_KEY') do
        Rails.application.credentials.dig(:jwt, :secret_key) ||
          raise(StandardError, 'JWT_SECRET_KEY not configured. Set ENV["JWT_SECRET_KEY"] or configure credentials.')
      end
    end
  end
end
