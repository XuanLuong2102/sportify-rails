class Expense < ApplicationRecord
  enum :owner_type, { admin: 0, agency: 1 }

  belongs_to :place,
             foreign_key: :owner_id,
             primary_key: :place_id,
             optional: true

  enum :expense_type, {
    inventory: 0,
    marketing: 1,
    operation: 2,
    salary: 3,
    maintenance: 4,
    other: 99
  }

  validates :amount_vnd, numericality: { greater_than_or_equal_to: 0 }
  validates :amount_usd, numericality: { greater_than_or_equal_to: 0 }
end
