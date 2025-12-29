class Admin::AdminController < ApplicationController
  include ErrorHandleConcern

  layout 'admin'

  before_action :authorize_admin!
  helper_method :current_user, :present_user?, :admin?

  private

  def authorize_admin!
    unless current_admin_user.present? && (current_admin_user.admin?)
      redirect_to new_admin_user_session_path, alert: I18n.t('admin.errors.forbidden')
    end
  end

  def current_user
    current_admin_user
  end
  
  def present_user?
    current_user.present?
  end

  def admin?
    current_user&.admin?
  end
end
