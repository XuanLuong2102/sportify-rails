class Payment < ApplicationRecord
  belongs_to :booking, optional: true
  belongs_to :recurring_booking, optional: true
  belongs_to :user, foreign_key: "user_id"
end
