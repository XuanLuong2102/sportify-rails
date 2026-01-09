class StockInbound < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product_variant
  belongs_to :supplier

  validates :quantity, numericality: { greater_than: 0 }
  validates :received_at, presence: true
  validates :cost_price_vnd, numericality: { greater_than_or_equal_to: 0 }

  before_create :generate_batch_number

  def self.ransackable_attributes(auth_object = nil)
    %w[reference_code received_at warehouse_id supplier_id product_variant_id batch_number]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[warehouse supplier product_variant]
  end

  private

  def generate_batch_number
    self.batch_number ||= "BATCH-#{Time.current.strftime('%Y%m%d%H%M%S')}-#{SecureRandom.hex(3)}"
  end
end
