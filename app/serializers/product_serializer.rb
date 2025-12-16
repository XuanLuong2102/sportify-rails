class ProductSerializer < BaseSerializer
  attributes :id, :name, :description, :thumbnail_url, :is_active

  belongs_to :brand, serializer: ProductBrandSerializer
  belongs_to :category, serializer: ProductCategorySerializer
end
