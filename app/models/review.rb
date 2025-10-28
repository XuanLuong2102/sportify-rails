class Review < ApplicationRecord
  belongs_to :user
  belongs_to :place_sport
end
