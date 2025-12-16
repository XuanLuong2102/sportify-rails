class ProductImageSerializer < BaseSerializer
  attributes :id, :image_url, :view_type, :sort_order

  belongs_to :product_color, serializer: ProductColorSerializer
end
