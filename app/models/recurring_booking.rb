class RecurringBooking < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :place_sport

  has_many :bookings
  has_many :payments
end
