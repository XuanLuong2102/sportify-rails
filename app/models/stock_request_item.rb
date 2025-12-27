class StockRequestItem < ApplicationRecord
  belongs_to :stock_request
  belongs_to :product_variant

  validates :requested_quantity,
            numericality: { greater_than: 0 }
end
