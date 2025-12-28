class Supplier < ApplicationRecord
  has_many :stock_inbounds

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }

  def soft_delete!
    update!(is_active: false)
  end

  def restore!
    update!(is_active: true)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[code contact_name name phone email]
  end

  def self.ransackable_associations(auth_object = nil)
    ['stock_inbounds']
  end
end