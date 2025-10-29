class Booking < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :place_sport
  belongs_to :recurring_booking, optional: true
  belongs_to :field_schedule, foreign_key: "schedule_id", optional: true

  has_many :payments
end
