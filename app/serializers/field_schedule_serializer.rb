class FieldScheduleSerializer < BaseSerializer
  attributes :id, :place_sport_id, :start_time, :end_time, :day_of_week

  belongs_to :place_sport
  has_many :bookings
end
