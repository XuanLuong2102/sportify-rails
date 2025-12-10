class PlaceSerializer < BaseSerializer
  attributes :place_id, :name, :address, :description

  has_many :place_sports
  has_many :place_managers

  attribute :name do
    object.name
  end
end
