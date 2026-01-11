# frozen_string_literal: true

module Agency
  class ProductsController < Agency::AgencyController
    include PaginatableConcern

    before_action :set_product, only: [:show]

    def index
      @q = agency_products.ransack(params[:q])
      @products = @q.result(distinct: true)
                    .includes(:product_brand, :category, product_variants: :product_stocks)
                    .order(created_at: :desc)
                    .paginate(page: params[:page], per_page: params[:per_page])
    end

    def show
      @product = Product.includes(:product_brand, :category,
                                  product_variants: [:product_color, :product_size, :product_stocks],
                                  product_images: [],
                                  product_listings: :place)
                        .find(params[:id])
    end

    private

    def agency_products
      # Get products that are listed in any of the agency's places
      Product.joins(:product_listings)
             .where(product_listings: { place_id: current_agency_place_ids })
             .distinct
    end

    def set_product
      @product = agency_products.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to agency_products_path, alert: I18n.t('agency.products.not_found')
    end
  end
end
