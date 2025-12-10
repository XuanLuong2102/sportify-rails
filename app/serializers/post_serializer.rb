class PostSerializer < BaseSerializer
  attributes :id, :user_id, :title, :content, :created_at

  belongs_to :user
end
