class Api::V1::ProductsController < Api::ApiController
  skip_before_action :authenticate_user!
  
  def index
    products = fetch_products_with_filters
    
    render_success(
      serialize_resource(products, serializer: ProductSerializer),
      message: I18n.t('api.products.fetched_products_success'),
      meta: pagination_meta(products)
    )
  end

  def show
    product = find_product_with_details
    
    return render_not_found(message: I18n.t('api.products.not_found')) unless product

    render_success(
      serialize_resource(product, serializer: ProductDetailSerializer),
      message: I18n.t('api.products.fetched_product_success')
    )
  end

  private

  def fetch_products_with_filters
    products = Product.active
    products = apply_search_filters(products) if search_params_present?
    products = products.preload(basic_product_includes)
    paginate_products(products)
  end

  def find_product_with_details
    Product
      .includes(detail_product_includes)
      .active
      .find_by(id: params[:id])
  end

  def apply_search_filters(products)
    products.ransack(params[:q]).result(distinct: true)
  end

  def paginate_products(products)
    products.paginate(
      page: params[:page],
      per_page: params[:per_page]
    )
  end

  def search_params_present?
    params[:q].present?
  end

  def basic_product_includes
    [
      :brand,
      :category,
      product_variants: [:product_color, :product_size],
      product_listings: :place
    ]
  end

  def detail_product_includes
    [
      :brand,
      :category,
      { product_variants: [:product_color, :product_size] },
      { product_images: :product_color },
      { product_listings: { product_reviews: :user } }
    ]
  end
end
