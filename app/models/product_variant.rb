class ProductVariant < ApplicationRecord
  belongs_to :product
  belongs_to :product_color, optional: true
  belongs_to :product_size, optional: true

  has_many :product_stocks, dependent: :destroy

  scope :active, -> { where(is_active: true) }

  validates :price_vnd, presence: true
  validates :sku, uniqueness: true, allow_nil: true
end
