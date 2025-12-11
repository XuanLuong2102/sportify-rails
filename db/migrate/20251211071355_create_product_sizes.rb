class CreateProductSizes < ActiveRecord::Migration[8.1]
  def change
    create_table :product_sizes do |t|
      t.string   :name, null: false
      t.timestamps
    end
  end
end
