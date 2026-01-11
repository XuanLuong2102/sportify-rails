# frozen_string_literal: true

class Agency::SessionsController < Base::SessionsController
  protected

  def after_sign_in_path_for(_resource)
    agency_root_path
  end

  def authorized_user?
    resource&.agency?
  end

  def devise_scope_name
    :agency_user
  end

  def unauthorized_message_key
    'agency.sessions.unauthorized'
  end
end
