class UserSerializer < BaseSerializer
  attributes :user_id, :email, :first_name, :middle_name, :last_name, :fullname, :role_id

  belongs_to :role, serializer: RoleSerializer
  has_many :bookings
  has_many :recurring_bookings
  has_many :payments
  has_many :notifications
  has_many :posts
  has_many :reviews
  has_many :place_managers
end
