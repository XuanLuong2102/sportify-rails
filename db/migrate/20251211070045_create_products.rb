class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string   :name_vi, null: false
      t.string   :name_en, null: false
      t.text     :description_vi
      t.text     :description_en
      t.bigint  :category_id
      t.bigint  :brand_id
      t.boolean  :is_active, default: true
      t.string   :thumbnail_url
      t.timestamps
    end

    add_index :products, :category_id
    add_index :products, :brand_id

    add_foreign_key :products, :product_categories, column: :category_id
    add_foreign_key :products, :product_brands, column: :brand_id
  end
end
