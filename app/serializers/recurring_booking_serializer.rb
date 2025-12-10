class RecurringBookingSerializer < BaseSerializer
  attributes :id, :user_id, :place_sport_id, :repeat_type, :start_date, :end_date

  belongs_to :user
  belongs_to :place_sport

  has_many :bookings
  has_many :payments
end
