class ProductImage < ApplicationRecord
  belongs_to :product
  belongs_to :product_color, optional: true

  validates :image_url, presence: true
end
