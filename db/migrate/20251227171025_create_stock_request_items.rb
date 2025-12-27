class CreateStockRequestItems < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_request_items do |t|
      t.references :stock_request, null: false, foreign_key: true

      t.references :product_variant, null: false, foreign_key: true

      t.integer :requested_quantity, null: false

      t.timestamps
    end

    add_index :stock_request_items,
              [:stock_request_id, :product_variant_id],
              unique: true,
              name: "idx_unique_request_variant"
  end
end
