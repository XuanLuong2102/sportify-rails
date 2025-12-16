class Api::V1::ProductBrandsController < Api::ApiController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    product_brands = ProductBrand.all
    render_success(product_brands, message: 'Product brands retrieved successfully')
  end
end
