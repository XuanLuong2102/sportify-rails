class ProductListingSerializer < BaseSerializer
  attributes :id, :is_active, :sold_count

  belongs_to :place, serializer: PlaceSerializer
end
