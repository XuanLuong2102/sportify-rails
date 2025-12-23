class AddOrderToPayments < ActiveRecord::Migration[8.1]
  def change
    add_column :payments, :order_id, :bigint
    add_index  :payments, :order_id
    add_foreign_key :payments, :orders
  end
end
