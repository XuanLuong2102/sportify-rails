class RoleSerializer < BaseSerializer
  attributes :role_id, :name

  has_many :users
end
