# frozen_string_literal: true

module Agency
  class ProductListingsController < Agency::AgencyController
    include PaginatableConcern

    before_action :set_product_listing, only: [:show, :destroy, :soft_delete, :restore]

    def index
      @q = agency_product_listings.ransack(params[:q])
      @product_listings = @q.result(distinct: true)
                            .includes(product: { product_variants: :product_stocks }, place: [])
                            .order(created_at: :desc)
                            .paginate(page: params[:page], per_page: params[:per_page])
    end

    def show
      @product_listing = agency_product_listings
                          .includes(product: [:product_brand, :category, 
                                             product_variants: [:product_color, :product_size, :product_stocks],
                                             product_images: []], 
                                   place: [])
                          .find(params[:id])
    end

    def new
      @product_listing = ProductListing.new
      @available_places = current_agency_places
      @available_products = Product.active
    end

    def create
      @product_listing = ProductListing.new(product_listing_params)

      # Validate that the place belongs to the agency
      unless current_agency_place_ids.include?(@product_listing.place_id)
        redirect_to new_agency_product_listing_path, alert: I18n.t('agency.product_listings.invalid_place')
        return
      end

      if @product_listing.save
        redirect_to agency_product_listings_path, 
                    notice: I18n.t('agency.product_listings.created_successfully')
      else
        @available_places = current_agency_places
        @available_products = Product.active
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if @product_listing.destroy
        redirect_to agency_product_listings_path, 
                    notice: I18n.t('agency.product_listings.deleted_successfully')
      else
        redirect_to agency_product_listings_path, 
                    alert: I18n.t('agency.product_listings.delete_failed')
      end
    end

    def soft_delete
      if @product_listing.update(is_active: false)
        redirect_to agency_product_listings_path, 
                    notice: I18n.t('agency.product_listings.deleted_successfully')
      else
        redirect_to agency_product_listings_path, 
                    alert: I18n.t('agency.product_listings.delete_failed')
      end
    end

    def restore
      if @product_listing.update(is_active: true)
        redirect_to agency_product_listings_path, 
                    notice: I18n.t('agency.product_listings.restored_successfully')
      else
        redirect_to agency_product_listings_path, 
                    alert: I18n.t('agency.product_listings.restore_failed')
      end
    end

    private

    def agency_product_listings
      ProductListing.where(place_id: current_agency_place_ids)
    end

    def set_product_listing
      @product_listing = agency_product_listings.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to agency_product_listings_path, alert: I18n.t('agency.product_listings.not_found')
    end

    def product_listing_params
      params.require(:product_listing).permit(
        :product_id,
        :place_id,
        :is_active,
        :stock_quantity,
        :min_stock_level,
        :price_override_vnd,
        :price_override_usd
      )
    end
  end
end
