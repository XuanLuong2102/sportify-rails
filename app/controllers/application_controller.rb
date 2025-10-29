class ApplicationController < ActionController::Base
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale]&.to_sym.presence_in(I18n.available_locales) || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }.compact
  end
end
