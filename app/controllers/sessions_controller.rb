class SessionsController < Devise::SessionsController
  layout 'devise'

  before_action :set_user, only: :create
  
  def create
    return render_locked_account if locked_account?
    return render_invalid_credentials if invalid_credentials?
    
    super
  end

  protected

  def after_sign_in_path_for(resource)
    admin_user?(resource) ? admin_root_path : root_path
  end

  private

  def set_user
    self.resource = User.find_by(email: user_email)
  end

  def user_email
    params.dig(:user, :email)
  end

  def user_password
    params.dig(:user, :password)
  end

  def admin_user?(user)
    user.admin? || user.agency?
  end

  def locked_account?
    resource&.is_locked && valid_password?
  end

  def invalid_credentials?
    resource.blank? || !valid_password?
  end

  def valid_password?
    resource&.valid_password?(user_password)
  end

  def render_locked_account
    set_flash_and_render('text.blocked_account')
  end

  def render_invalid_credentials
    self.resource ||= User.new(email: user_email)
    set_flash_and_render('devise.failure.user.invalid_credentials')
  end

  def set_flash_and_render(message_key)
    flash.now[:alert] = I18n.t(message_key)
    render :new, status: :unprocessable_entity
  end
end
