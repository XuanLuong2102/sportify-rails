class Admin::ProductListingsController < Admin::AdminController
  include PaginatableConcern

  before_action :set_place
  before_action :per_page_default, only: [:index]

  def index
    @q = @place.product_listings.includes(:product).ransack(params[:q])
    @product_listings = @q.result(distinct: true)
    @product_listings = @product_listings.paginate(page: params[:page], per_page: params[:per_page])
  end

  private

  def set_place
    @place = Place.find(params[:place_id])
  end

  def per_page_default
    params[:per_page] = 10
  end
end
