# frozen_string_literal: true

class Agency::AgencyController < ApplicationController
  include ErrorHandleConcern

  layout 'agency'

  before_action :authorize_agency!
  helper_method :current_user, :present_user?, :agency?, :current_agency_places

  private

  def authorize_agency!
    unless current_agency_user.present? && current_agency_user.agency?
      redirect_to new_agency_user_session_path, alert: I18n.t('agency.errors.forbidden')
    end
  end

  def current_user
    current_agency_user
  end

  def present_user?
    current_user.present?
  end

  def agency?
    current_user&.agency?
  end

  # Returns all places managed by the current agency user
  def current_agency_places
    @current_agency_places ||= current_user.place_managers.includes(:place).map(&:place)
  end

  # Returns place IDs for the current agency
  def current_agency_place_ids
    @current_agency_place_ids ||= current_agency_places.map(&:place_id)
  end
end
