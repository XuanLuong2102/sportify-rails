class CreateOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :order_items do |t|
      t.bigint :order_id, null: false

      t.bigint :product_id, null: false
      t.bigint :product_variant_id

      t.integer :quantity, null: false, default: 1

      t.string  :product_name, null: false
      t.string  :variant_name
      t.decimal :unit_price_vnd, precision: 10, scale: 2, null: false
      t.decimal :unit_price_usd, precision: 10, scale: 2, null: false
      t.decimal :total_price_vnd, precision: 10, scale: 2, null: false
      t.decimal :total_price_usd, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :order_items, :order_id
    add_index :order_items, :product_id
    add_index :order_items, :product_variant_id

    add_foreign_key :order_items, :orders
    add_foreign_key :order_items, :products
    add_foreign_key :order_items, :product_variants
  end
end
