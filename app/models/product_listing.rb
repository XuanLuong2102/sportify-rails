class ProductListing < ApplicationRecord
  belongs_to :product
  belongs_to :place

  has_many :product_stocks, dependent: :destroy
  has_many :product_reviews, dependent: :destroy

  scope :active, -> { where(is_active: true) }

  def self.ransackable_associations(_auth = nil)
    %w[place]
  end
end
