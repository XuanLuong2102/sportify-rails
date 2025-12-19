module Api
  module V1
    class SessionsController < Api::ApiController
      skip_before_action :authenticate_user!, only: :create

      def create
        user = User.find_by(email: session_params[:email].to_s.downcase)

        unless user&.valid_password?(session_params[:password])
          return render_error(
            401,
            I18n.t('api.user.errors.invalid_credentials')
          )
        end

        token = JwtService.encode_user(user)

        render_success(
          {
            token: token,
            user: serialize_resource(user, serializer: UserSerializer)
          },
          message: I18n.t('api.user.messages.login_success')
        )
      end

      private

      def session_params
        params.permit(:email, :password)
      end
    end
  end
end
