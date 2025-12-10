module Api
  class ApiController < ActionController::API
    include ActionController::MimeResponds
    include ErrorHandleConcern
    include PaginatableConcern
    include Pundit::Authorization

    before_action :authenticate_user!
    before_action :log_api_request

    rescue_from Pundit::NotAuthorizedError, with: :handle_forbidden

    attr_reader :current_user

    private

    # ==================== Authentication ====================

    def authenticate_user!
      token = extract_token
      raise UnauthorizedError, I18n.t('api.errors.missing_token') unless token

      @current_user = JwtService.decode_user(token)
    end

    def extract_token
      header = request.headers['Authorization']
      return nil unless header&.match?(/^Bearer /i)

      header.split(' ').last
    end

    # ==================== Response Helpers ====================

    def render_success(data = {}, message: nil, status: :ok)
      render json: {
        success: true,
        message: message,
        data: data
      }, status: status
    end

    def render_error(status_code, message, errors: {})
      render json: {
        success: false,
        message: message,
        errors: errors
      }, status: status_code
    end

    # ==================== Error Handlers ====================

    def handle_forbidden(exception)
      message = exception.message.presence || I18n.t('api.errors.forbidden')
      render_error(403, message)
    end

    # ==================== Query Validation ====================

    def validate_query_fields!(model_class)
      return true unless params[:q].present?

      invalid_fields = find_invalid_fields(model_class)
      return true if invalid_fields.empty?

      error_message = I18n.t('api.errors.invalid_fields', 
                              fields: invalid_fields.join(', '))
      render_error(400, error_message, errors: { invalid_fields: invalid_fields })
      
      false
    end

    def find_invalid_fields(model_class)
      return [] unless model_class.respond_to?(:ransackable_attributes)

      allowed_fields = model_class.ransackable_attributes
      input_fields - allowed_fields
    end

    def input_fields
      return [] unless params[:q].is_a?(ActionController::Parameters)

      params[:q].keys.map do |key|
        # Remove Ransack predicates
        key.to_s.sub(/_(?:eq|lteq|gteq|lt|gt|cont|in|not_eq|start|end|matches|does_not_match|present|blank|null|not_null)$/, '')
      end.uniq
    end

    # ==================== Logging ====================

    def log_api_request
      return unless Rails.env.production?

      Rails.logger.info({
        type: 'api_request',
        method: request.method,
        path: request.path,
        user_id: current_user&.id,
        ip: request.remote_ip,
        user_agent: request.user_agent,
        timestamp: Time.current
      }.to_json)
    end
  end
end
