class CreateStockInbounds < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_inbounds do |t|
      t.references :warehouse, null: false, foreign_key: true
      t.references :product_variant, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :cost_price_vnd, precision: 10, scale: 2
      t.decimal :cost_price_usd, precision: 10, scale: 2
      t.references :supplier, null: false, foreign_key: true
      t.string :reference_code
      t.datetime :received_at, null: false
      t.timestamps
    end

    add_index :stock_inbounds, :received_at
  end
end
