class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.bigint :booking_id
      t.bigint :recurring_booking_id
      t.integer :user_id, null: false
      t.integer :payment_option, default: 0, null: false
      t.decimal :amount, precision: 10, scale: 2
      t.string  :currency, limit: 10
      t.string  :status, limit: 50
      t.string  :transaction_id, limit: 255
      t.datetime :paid_at

      t.timestamps
    end

    add_foreign_key :payments, :bookings
    add_foreign_key :payments, :recurring_bookings
    add_foreign_key :payments, :users, column: :user_id, primary_key: :user_id
  end
end
