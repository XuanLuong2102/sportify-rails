class Warehouse < ApplicationRecord
  has_many :warehouse_stocks
  has_many :stock_inbounds
  has_many :stock_transfers

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  scope :active, -> { where(is_active: true) }

  def self.ransackable_attributes(auth_object = nil)
    %w[code name location is_active created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[warehouse_stocks stock_inbounds stock_transfers]
  end
end
