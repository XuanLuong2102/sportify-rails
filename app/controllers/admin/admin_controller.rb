class Admin::AdminController < ApplicationController
  include ErrorHandleConcern

  layout 'admin'

  before_action :authorize_admin!

  private

  def authorize_admin!
    return if present_user? && admin?

    raise ForbiddenError.new(
      I18n.t('api.admin.errors.forbidden', default: 'Admin permission required')
    )
  end
  
  def present_user?
    current_user.present?
  end

  def admin?
    current_user&.admin?
  end
end
