class ProductStock < ApplicationRecord
  belongs_to :product_listing
  belongs_to :product_variant

  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
end
