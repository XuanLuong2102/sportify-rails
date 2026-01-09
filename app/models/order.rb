class Order < ApplicationRecord
  belongs_to :user
  belongs_to :place, foreign_key: 'place_id', primary_key: 'place_id'

  has_many :order_items, dependent: :destroy
  has_many :payments

  validates :order_code, presence: true, uniqueness: true
  validates :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[order_code status created_at ordered_at paid_at cancelled_at 
       total_amount_vnd total_amount_usd user_id place_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user place order_items payments]
  end

  def payment_status
    payments.last&.status || 'unpaid'
  end

  def paid?
    ['completed', 'success', 'paid'].include?(payment_status)
  end
end
