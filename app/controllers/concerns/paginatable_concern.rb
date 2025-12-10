module PaginatableConcern
  extend ActiveSupport::Concern
  DEFAULT_PAGE_SIZE = 20

  included do
    before_action :set_pagination_params
  end

  private

  def set_pagination_params
    params[:page] = (params[:page] || 1).to_i
    params[:per_page] = (params[:per_page] || DEFAULT_PAGE_SIZE).to_i
  end
end
