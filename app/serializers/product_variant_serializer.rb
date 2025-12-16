class ProductVariantSerializer < BaseSerializer
  attributes :id, :sku, :price_vnd, :price_usd, :is_active

  belongs_to :product_color, serializer: ProductColorSerializer
  belongs_to :product_size, serializer: ProductSizeSerializer
end
