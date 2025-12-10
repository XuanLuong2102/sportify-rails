module ErrorHandleConcern
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from UnauthorizedError, with: :handle_unauthorized
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActionController::ParameterMissing, with: :handle_bad_request
    rescue_from ActionController::BadRequest, with: :handle_bad_request
  end

  private

  def handle_bad_request(exception)
    render_error(400, exception.message)
  end

  def handle_unauthorized(exception)
    render_error(401, exception.message)
  end

  def handle_not_found(exception)
    message = exception.model ? 
              I18n.t('api.errors.not_found', model: exception.model) :
              exception.message
    render_error(404, message)
  end

  def handle_record_invalid(exception)
    render_error(
      422, 
      I18n.t('api.errors.validation_failed'),
      errors: format_validation_errors(exception.record.errors)
    )
  end

  def handle_standard_error(exception)
    log_error(exception)
    
    # Don't expose internal errors in production
    message = Rails.env.production? ? 
              I18n.t('api.errors.internal_server_error') : 
              exception.message
    
    render_error(500, message)
  end

  def render_error(status_code, message, errors: {})
    respond_to do |format|
      format.json do
        render json: error_json_response(status_code, message, errors), 
               status: status_code
      end
      format.html do
        render_html_error(status_code)
      end
    end
  end

  def error_json_response(status_code, message, errors)
    {
      success: false,
      message: message,
      errors: errors
    }.compact
  end

  def format_validation_errors(errors)
    errors.messages.transform_values do |messages|
      messages.join(', ')
    end
  end

  def log_error(exception)
    Rails.logger.error({
      type: 'unhandled_error',
      error_class: exception.class.name,
      message: exception.message,
      backtrace: exception.backtrace&.first(10),
      request_path: request.path,
      request_method: request.method,
      user_id: respond_to?(:current_user) ? current_user&.id : nil,
      timestamp: Time.current
    }.to_json)
  end

  def render_html_error(status_code)
    file_path = Rails.root.join('public', "#{status_code}.html")
    
    if File.exist?(file_path)
      render file: file_path, layout: false, status: status_code
    else
      render plain: "Error #{status_code}", status: status_code
    end
  end
end

# Custom error classes
class UnauthorizedError < StandardError
  def initialize(message = 'Unauthorized access')
    super(message)
  end
end

class ForbiddenError < StandardError
  def initialize(message = 'Forbidden')
    super(message)
  end
end
