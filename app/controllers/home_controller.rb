class HomeController < ApplicationController
  layout 'user'

  def index
    # Fetch some featured data for the home page
    @featured_places = Place.where(is_close: false, maintenance_place: false).limit(6)
    @featured_products = Product.where(is_active: true).includes(:product_brand, :category).limit(8)
  end
end
