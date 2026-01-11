class Admin::SessionsController < Base::SessionsController
  protected

  def after_sign_in_path_for(_resource)
    admin_root_path
  end

  def authorized_user?
    resource&.admin?
  end

  def devise_scope_name
    :admin_user
  end

  def unauthorized_message_key
    'admin.sessions.unauthorized'
  end
end
