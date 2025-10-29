class Role < ApplicationRecord
	self.primary_key = "role_id"

  has_many :users
end
