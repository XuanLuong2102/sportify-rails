class Warehouse < ApplicationRecord
  has_many :warehouse_stocks
  has_many :stock_inbounds
  has_many :stock_transfers

  validates :code, presence: true, uniqueness: true
end
