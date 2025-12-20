class Role < ApplicationRecord
	self.primary_key = "role_id"

  has_many :users

  def self.ransackable_attributes(_auth = nil)
    %w[name]
  end
end
