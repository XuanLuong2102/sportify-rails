class CreateProductBrands < ActiveRecord::Migration[8.1]
  def change
    create_table :product_brands do |t|
      t.string   :name, null: false
      t.timestamps
    end
  end
end
