class CreateProductVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :product_variants do |t|
      t.bigint  :product_id, null: false
      t.bigint  :product_color_id
      t.bigint  :product_size_id
      t.string   :sku
      t.decimal  :price_vnd, precision: 10, scale: 2, null: false
      t.decimal  :price_usd, precision: 10, scale: 2
      t.boolean  :is_active, default: true
      t.timestamps
    end

    add_index :product_variants, :product_id
    add_index :product_variants, :product_color_id
    add_index :product_variants, :product_size_id
    add_index :product_variants, :sku, unique: true
    add_index :product_variants, [:product_id, :product_color_id, :product_size_id], unique: true

    add_foreign_key :product_variants, :products, column: :product_id
    add_foreign_key :product_variants, :product_colors, column: :product_color_id
    add_foreign_key :product_variants, :product_sizes, column: :product_size_id
  end
end
