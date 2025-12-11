class CreateProductListings < ActiveRecord::Migration[8.1]
  def change
    create_table :product_listings do |t|
      t.integer  :place_id, null: false
      t.bigint  :product_id, null: false
      t.boolean  :is_active, default: true
      t.integer  :sold_count, default: 0, null: false
      t.timestamps
    end

    add_index :product_listings, [:place_id, :product_id], unique: true

    add_foreign_key :product_listings, :places, column: :place_id, primary_key: :place_id
    add_foreign_key :product_listings, :products, column: :product_id
  end
end
