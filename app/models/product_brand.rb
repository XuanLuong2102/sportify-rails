class ProductBrand < ApplicationRecord
  has_many :products, foreign_key: :brand_id, dependent: :nullify

  validates :name, presence: true
end
