class Booking < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :place_sport
  belongs_to :recurring_booking, optional: true
  belongs_to :field_schedule, foreign_key: "schedule_id", optional: true

  has_many :payments

  # Scopes for agency filtering
  scope :for_agency_places, ->(place_ids) {
    joins(place_sport: :place)
      .where(places: { place_id: place_ids })
  }
  
  scope :for_agency_user, ->(user) {
    place_ids = user.managed_place_ids
    for_agency_places(place_ids)
  }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "place_sport_id", "recurring_booking_id", "schedule_id", "status", "total_price", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "place_sport", "recurring_booking", "field_schedule", "payments"]
  end
end
