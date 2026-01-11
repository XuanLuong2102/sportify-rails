# frozen_string_literal: true

module Base
  class SessionsController < Devise::SessionsController
    layout 'devise'

    before_action :set_user, only: :create

    def create
      return render_invalid_credentials if invalid_credentials?
      return render_locked_account if locked_account?
      return render_unauthorized unless authorized_user?

      super
    end

    protected

    # Override in subclasses to define redirect path after sign in
    def after_sign_in_path_for(_resource)
      raise NotImplementedError, 'Subclasses must implement after_sign_in_path_for'
    end

    # Override in subclasses to define authorization rules
    def authorized_user?
      raise NotImplementedError, 'Subclasses must implement authorized_user?'
    end

    # Override in subclasses to define the devise scope name
    def devise_scope_name
      raise NotImplementedError, 'Subclasses must implement devise_scope_name'
    end

    private

    # ===== Helpers =====

    def set_user
      self.resource = User.find_by(email: user_email)
    end

    def user_email
      params.dig(devise_scope_name, :email)
    end

    def user_password
      params.dig(devise_scope_name, :password)
    end

    def valid_password?
      resource&.valid_password?(user_password)
    end

    # ===== Guards =====

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
      render_error(unauthorized_message_key)
    end

    def render_invalid_credentials
      self.resource ||= User.new(email: user_email)
      render_error('devise.failure.user.invalid_credentials')
    end

    def render_error(message_key)
      flash.now[:alert] = I18n.t(message_key)
      render :new, status: :unprocessable_content
    end

    # Override in subclasses to customize unauthorized message
    def unauthorized_message_key
      'admin.sessions.unauthorized'
    end
  end
end
