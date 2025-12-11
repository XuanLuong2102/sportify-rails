class CreateProductColors < ActiveRecord::Migration[8.1]
  def change
    create_table :product_colors do |t|
      t.string   :name, null: false
      t.string   :code_rgb
      t.timestamps
    end

    add_index :product_colors, [:name, :code_rgb], unique: true
  end
end
