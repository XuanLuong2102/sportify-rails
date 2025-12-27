class StockTransfer < ApplicationRecord
  belongs_to :stock_request

  belongs_to :warehouse
  belongs_to :place

  belongs_to :product_variant
  belongs_to :transferred_by,
             class_name: "User",
             foreign_key: :transferred_by_id,
             primary_key: :user_id,
             optional: true
end
