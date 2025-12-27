class StockRequest < ApplicationRecord
  belongs_to :place

  belongs_to :requester,
             class_name: :User,
             foreign_key: :requested_by_id,
             primary_key: :user_id

  belongs_to :approver,
             class_name: :User,
             foreign_key: :approved_by_id,
             primary_key: :user_id,
             optional: true

  has_many :stock_request_items, dependent: :destroy

  enum status: { pending: 0, approved: 1, rejected: 2, cancelled: 3 }
end
