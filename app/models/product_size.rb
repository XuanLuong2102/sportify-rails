class ProductSize < ApplicationRecord
  has_many :product_variants

  validates :name, presence: true

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
    %w[name deleted_at]
  end
end
