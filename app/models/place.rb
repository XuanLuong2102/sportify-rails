class Place < ApplicationRecord
  self.primary_key = "place_id"

  has_many :place_sports
  has_many :place_managers
end
