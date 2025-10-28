class PlaceSport < ApplicationRecord
  belongs_to :place, foreign_key: "place_id"
  belongs_to :sportfield, foreign_key: "sportfield_id"

  has_many :field_schedules
  has_many :bookings
  has_many :recurring_bookings
  has_many :reviews
end
