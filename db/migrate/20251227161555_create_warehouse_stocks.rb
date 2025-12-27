class CreateWarehouseStocks < ActiveRecord::Migration[8.1]
  def change
    create_table :warehouse_stocks do |t|
      t.references :warehouse, null: false, foreign_key: true
      t.references :product_variant, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0
      t.timestamps
    end

    add_index :warehouse_stocks,
              [:warehouse_id, :product_variant_id],
              unique: true,
              name: "idx_unique_warehouse_variant"
  end
end
