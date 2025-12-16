class ProductDetailSerializer < BaseSerializer
  attributes :id, :name, :description, :thumbnail_url, :is_active

  belongs_to :brand, serializer: ProductBrandSerializer
  belongs_to :category, serializer: ProductCategorySerializer

  has_many :product_variants, serializer: ProductVariantSerializer
  has_many :product_images, serializer: ProductImageSerializer
  has_many :product_reviews, serializer: ProductReviewSerializer
end
