class ProductColor < ApplicationRecord
  has_many :product_variants
  has_many :product_images

  validates :name, presence: true
  validates :code_rgb, uniqueness: { scope: :name }, allow_nil: true

  def self.ransackable_attributes(_auth = nil)
    %w[name]
  end
end
