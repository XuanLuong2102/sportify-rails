class PlaceManager < ApplicationRecord
  belongs_to :user
  belongs_to :place
  # searchable virtual attributes for joins
  ransacker :place_name do |parent|
    Arel.sql("CONCAT(places.name_en, ' ', places.name_vi)")
  end

  ransacker :user_full_name do |parent|
    Arel.sql("CONCAT(users.first_name, ' ', users.last_name)")
  end

  def self.ransackable_attributes(_auth = nil)
    %w[id user_id place_id created_at updated_at place_name user_full_name]
  end

  def self.ransackable_associations(_auth = nil)
    %w[user place]
  end
end
