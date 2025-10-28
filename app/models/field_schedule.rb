class FieldSchedule < ApplicationRecord
  belongs_to :place_sport

  has_many :bookings, foreign_key: "schedule_id"
end
