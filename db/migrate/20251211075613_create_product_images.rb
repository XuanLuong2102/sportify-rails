class CreateProductImages < ActiveRecord::Migration[8.1]
  def change
    create_table :product_images do |t|
      t.bigint :product_id, null: false
      t.bigint :product_color_id, null: true
      t.string  :image_url, null: false
      t.integer :sort_order, null: false, default: 0
      t.string  :view_type
      t.timestamps
    end

    add_index :product_images, :product_id
    add_index :product_images, :product_color_id
    add_index :product_images, [:product_id, :product_color_id, :image_url], unique: true, name: "idx_unique_color_image", where: 'product_color_id IS NOT NULL'
    add_index :product_images, [:product_id, :image_url], unique: true, name: "idx_unique_product_image", where: "product_color_id IS NULL"

    add_foreign_key :product_images, :products, column: :product_id
    add_foreign_key :product_images, :product_colors, column: :product_color_id
  end
end
