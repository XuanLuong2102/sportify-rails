class ReviewSerializer < BaseSerializer
  attributes :id, :user_id, :place_sport_id, :rating, :comment

  belongs_to :user
  belongs_to :place_sport
end
