  class CreateOrders < ActiveRecord::Migration[8.1]
    def change
      create_table :orders do |t|
        t.integer :user_id, null: false
        t.integer  :place_id, null: false

        t.string  :order_code, null: false
        t.string  :status, limit: 50, default: 'pending', null: false

        t.decimal :subtotal_amount_vnd, precision: 10, scale: 2, null: false
        t.decimal :subtotal_amount_usd, precision: 10, scale: 2, null: false
        t.decimal :shipping_fee_vnd, precision: 10, scale: 2, default: 0, null: false
        t.decimal :shipping_fee_usd, precision: 10, scale: 2, default: 0, null: false
        t.decimal :total_amount_vnd, precision: 10, scale: 2, null: false
        t.decimal :total_amount_usd, precision: 10, scale: 2, null: false

        t.string :shipping_receiver_name, null: false
        t.string :shipping_phone, null: false
        t.text   :shipping_address, null: false
        
        t.datetime :ordered_at
        t.datetime :paid_at
        t.datetime :cancelled_at

        t.timestamps
      end

      add_index :orders, :user_id
      add_index :orders, :place_id
      add_index :orders, :order_code, unique: true

      add_foreign_key :orders, :users, column: :user_id, primary_key: :user_id
      add_foreign_key :orders, :places, column: :place_id, primary_key: :place_id
    end
  end
