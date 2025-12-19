class UserDetailSerializer < UserSerializer
  attributes :phone, :gender, :is_locked, :created_at

  has_many :place_managers
  has_many :notifications
end
