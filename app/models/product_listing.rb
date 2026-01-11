class ProductListing < ApplicationRecord
  belongs_to :product
  belongs_to :place

  has_many :product_stocks, dependent: :destroy
  has_many :product_reviews, dependent: :destroy

  scope :active, -> { where(is_active: true) }
  
  # Scopes for agency filtering
  scope :for_agency_places, ->(place_ids) { where(place_id: place_ids) }
  scope :for_agency_user, ->(user) { 
    place_ids = user.managed_place_ids
    where(place_id: place_ids)
  }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "is_active", "place_id", "product_id", "sold_count", "updated_at"]
  end

  def self.ransackable_associations(_auth = nil)
    %w[place product]
  end
end
