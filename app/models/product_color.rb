class ProductColor < ApplicationRecord
  has_many :product_variants
  has_many :product_images

  validates :name, presence: true
  validates :code_rgb, uniqueness: { scope: :name }, allow_nil: true

  # Soft delete
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end

  def self.ransackable_attributes(_auth = nil)
    %w[name code_rgb deleted_at]
  end
end
