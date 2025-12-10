class BookingSerializer < BaseSerializer
  attributes :id, :user_id, :place_sport_id, :schedule_id,
             :recurring_booking_id, :start_time, :end_time, :status

  belongs_to :user
  belongs_to :place_sport
  belongs_to :recurring_booking
  belongs_to :field_schedule, key: :schedule

  has_many :payments
end
