class ProductReviewSerializer < BaseSerializer
  attributes :id, :rating, :comment, :created_at

  belongs_to :user, serializer: UserSerializer
end
