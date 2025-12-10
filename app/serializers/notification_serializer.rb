class NotificationSerializer < BaseSerializer
  attributes :id, :user_id, :title, :message, :read, :created_at

  belongs_to :user
end
