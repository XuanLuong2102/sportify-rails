class Sportfield < ApplicationRecord
  self.primary_key = "sportfield_id"

  has_many :place_sports
end
