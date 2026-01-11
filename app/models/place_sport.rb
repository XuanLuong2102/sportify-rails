class PlaceSport < ApplicationRecord
  include PriceConvertible

  convert_price vnd: :price_per_hour_vnd,
                usd: :price_per_hour_usd

  belongs_to :place, foreign_key: "place_id"
  belongs_to :sportfield, foreign_key: "sportfield_id"

  has_many :field_schedules
  has_many :bookings
  has_many :recurring_bookings
  has_many :reviews

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "is_close", "maintenance_sport", "place_id", "price_per_hour_usd", "price_per_hour_vnd", "sportfield_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["place", "sportfield"]
  end

  def price_per_hour
    I18n.locale == :en ? price_per_hour_usd : price_per_hour_vnd
  end
end
