class CreateProductCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :product_categories do |t|
      t.string   :name_vi, null: false
      t.string   :name_en, null: false
      t.text     :description_vi
      t.text     :description_en
      t.timestamps
    end
  end
end
