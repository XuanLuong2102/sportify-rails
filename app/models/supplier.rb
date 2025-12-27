class Supplier < ApplicationRecord
  has_many :stock_inbounds

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
