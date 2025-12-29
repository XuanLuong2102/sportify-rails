class Admin::SessionsController < Devise::SessionsController
  layout 'devise'

  before_action :set_user, only: :create

  def create
    return render_invalid_credentials if invalid_credentials?
    return render_locked_account if locked_account?
    return render_unauthorized unless admin_user?

    super
  end

  protected

  def after_sign_in_path_for(_resource)
    admin_root_path
  end

  private

  # ===== Helpers =====

  def set_user
    self.resource = User.find_by(email: user_email)
  end

  def user_email
    params.dig(:admin_user, :email)
  end

  def user_password
    params.dig(:admin_user, :password)
  end

  def valid_password?
    resource&.valid_password?(user_password)
  end

  # ===== Guards =====

  def admin_user?
    resource&.admin? || resource&.agency?
  end

  def locked_account?
    resource&.is_locked && valid_password?
  end

  def invalid_credentials?
    resource.blank? || !valid_password?
  end

  # ===== Render helpers =====

  def render_locked_account
    render_error('text.blocked_account')
  end

  def render_unauthorized
    render_error('admin.sessions.unauthorized')
  end

  def render_invalid_credentials
    self.resource ||= User.new(email: user_email)
    render_error('devise.failure.user.invalid_credentials')
  end

  def render_error(message_key)
    flash.now[:alert] = I18n.t(message_key)
    render :new, status: :unprocessable_content
  end
end
