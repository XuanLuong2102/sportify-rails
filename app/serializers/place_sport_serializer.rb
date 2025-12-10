class PlaceSportSerializer < BaseSerializer
  attributes :id, :place_id, :sportfield_id, :price, :is_close

  belongs_to :place
  belongs_to :sportfield

  has_many :field_schedules
  has_many :bookings
  has_many :recurring_bookings
  has_many :reviews

  def price
    locale_price = I18n.locale == :vi ? object.price_per_hour_vnd : object.price_per_hour_usd
    locale_price.to_s
  end
end
