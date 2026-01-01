class Admin::ProductListingsController < Admin::AdminController
  include PaginatableConcern

  before_action :set_place
  before_action :set_product_listing, only: %i[edit update destroy soft_delete restore]
  before_action :per_page_default, only: [:index]

  def index
    @q = @place.product_listings.includes(:product).ransack(params[:q])
    @product_listings = @q.result(distinct: true)
    @product_listings = @product_listings.paginate(page: params[:page], per_page: params[:per_page])
  end

  def new
    @product_listing = @place.product_listings.new
    load_collections
  end

  def create
    @product_listing = @place.product_listings.new(product_listing_params)
    if @product_listing.save
      redirect_to admin_place_product_listings_path(@place), notice: t('product_listings.notices.created')
    else
      load_collections
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_collections
  end

  def update
    if @product_listing.update(product_listing_params)
      redirect_to helpers.back_to_list(admin_place_product_listings_path(@place)), notice: t('product_listings.notices.updated')
    else
      load_collections
      render :edit, status: :unprocessable_entity
    end
  end

  def soft_delete
    if @product_listing.update(is_active: false)
      redirect_to admin_place_product_listings_path(@place), notice: 'Closed'
    else
      redirect_to admin_place_product_listings_path(@place), alert: 'Failed to close'
    end
  end

  def restore
    if @product_listing.update(is_active: true)
      redirect_to admin_place_product_listings_path(@place), notice: 'Restored'
    else
      redirect_to admin_place_product_listings_path(@place), alert: 'Failed to restore'
    end
  end

  def destroy
    @product_listing.destroy
    redirect_to helpers.back_to_list(admin_place_product_listings_path(@place)), notice: t('product_listings.notices.deleted')
  end

  private

  def set_place
    @place = Place.find(params[:place_id])
  end

  def set_product_listing
    @product_listing = @place.product_listings.find(params[:id])
  end

  def product_listing_params
    params.require(:product_listing).permit(:place_id, :product_id, :sold_count, :is_active)
  end

  def load_collections
    @products = Product.where(is_active: true).order(:name_en)
  end

  def per_page_default
    params[:per_page] = 10
  end
end
