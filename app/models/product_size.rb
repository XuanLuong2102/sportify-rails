class ProductSize < ApplicationRecord
  has_many :product_variants

  validates :name, presence: true

  def self.ransackable_attributes(_auth = nil)
    %w[name]
  end
end
