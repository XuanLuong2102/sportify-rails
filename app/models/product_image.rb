class ProductImage < ApplicationRecord
  belongs_to :product
  belongs_to :product_color, optional: true

  has_one_attached :image do |attachable|
    attachable.variant :image_50, resize_to_limit: [50, 50]
    attachable.variant :image_300, resize_to_limit: [300, 300]
  end
  validates :image_url, presence: true
end
