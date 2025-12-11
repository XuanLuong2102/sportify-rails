class CreateProductStocks < ActiveRecord::Migration[8.1]
  def change
    create_table :product_stocks do |t|
      t.bigint  :product_listing_id, null: false
      t.bigint  :product_variant_id, null: false
      t.integer  :stock_quantity, null: false, default: 0
      t.timestamps
    end

    add_index :product_stocks, [:product_listing_id, :product_variant_id], unique: true

    add_foreign_key :product_stocks, :product_listings, column: :product_listing_id
    add_foreign_key :product_stocks, :product_variants, column: :product_variant_id
  end
end
