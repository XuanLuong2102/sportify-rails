class CreateStockTransfers < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_transfers do |t|
      t.references :warehouse, null: false, foreign_key: true
      t.references :place,
                   type: :integer,
                   null: false,
                   foreign_key: { to_table: :places, primary_key: :place_id }
      t.references :product_variant, null: false, foreign_key: true
      t.references :stock_request, null: false, foreign_key: true
      t.references :transferred_by,
                   type: :integer,
                   null: false,
                   foreign_key: { to_table: :users, primary_key: :user_id }
      t.integer :quantity, null: false
      t.string :note
      t.datetime :transferred_at, null: false
      t.timestamps
    end

    add_index :stock_transfers, :transferred_at
  end
end
