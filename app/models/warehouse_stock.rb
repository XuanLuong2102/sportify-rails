class WarehouseStock < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product_variant

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
