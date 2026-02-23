class ProductsController < ApplicationController
  layout 'user'
  
  before_action :clean_cart_session, only: [:index]
  before_action :set_places, only: [:index]
  before_action :set_selected_place, only: [:index, :show]

  # GET /products - Product listing page
  def index
    @q = Product.active.ransack(ransack_params)
    @products = @q.result.includes(:product_brand, :category, :product_images,
                                    product_variants: [:product_color, :product_size, :product_stocks])
                       .distinct
    
    if @selected_place_id
      @products = @products.joins(:product_listings)
                           .where(product_listings: { place_id: @selected_place_id, is_active: true })
    end
    
    set_filter_options
    session[:cart] ||= {}
  end

  # GET /products/:place_id/:id - Product detail page
  def show
    @product = Product.includes(:product_brand, :category, :product_images,
                                product_variants: [:product_color, :product_size, :product_stocks])
                       .find(params[:id])
                      
    @current_listing = @product.product_listings.find_by(place_id: @selected_place_id, is_active: true)
    @available_places = @product.places.where(is_close: false).distinct
    
    @variants = @product.product_variants.active
    @colors = @variants.map(&:product_color).uniq.compact
    
    prepare_reviews_data
  end

  private

  def ransack_params
    q = params[:q] || {}
    # Map legacy params to ransack attributes
    q[:product_variants_product_color_id_eq] = params[:color_id] if params[:color_id].present?
    q[:product_variants_product_size_id_eq] = params[:size_id] if params[:size_id].present?
    q[:category_id_eq] = params[:category_id] if params[:category_id].present?
    q
  end

  def set_places
    @places = Place.joins(:product_listings).where(is_close: false).distinct
  end

  def set_selected_place
    @selected_place_id = params[:place_id].presence&.to_i
  end

  def clean_cart_session
    return unless session[:cart].present?
    session[:cart].delete_if { |vid, _| vid.blank? || !ProductVariant.exists?(vid) }
  end

  def set_filter_options
    base_scope = if @selected_place_id
      { product_listings: { place_id: @selected_place_id } }
    else
      {}
    end

    @colors = ProductColor.joins(product_variants: { product: :product_listings }).where(base_scope).distinct.order(:name)
    @sizes = ProductSize.joins(product_variants: { product: :product_listings }).where(base_scope).distinct.order(:name)
    @categories = ProductCategory.joins(products: :product_listings).where(base_scope).distinct.order(:name_en)
  end

  def prepare_reviews_data
    @reviews = @product.product_reviews.includes(:user).order(created_at: :desc)
    @total_reviews = @reviews.size
    @average_rating = @total_reviews > 0 ? @reviews.average(:rating).round(1) : 0
  end
end
