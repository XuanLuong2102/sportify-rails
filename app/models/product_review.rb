class ProductReview < ApplicationRecord
  belongs_to :product_listing
  belongs_to :user

  validates :rating, inclusion: { in: 1..5 }
end
