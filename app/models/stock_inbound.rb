class StockInbound < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product_variant
  belongs_to :supplier

  validates :quantity, numericality: { greater_than: 0 }
end
