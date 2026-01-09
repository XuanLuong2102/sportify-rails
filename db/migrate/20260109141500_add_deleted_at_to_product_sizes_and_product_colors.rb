class AddDeletedAtToProductSizesAndProductColors < ActiveRecord::Migration[8.1]
  def change
    add_column :product_sizes, :deleted_at, :datetime, default: nil
    add_column :product_colors, :deleted_at, :datetime, default: nil
    
    add_index :product_sizes, :deleted_at
    add_index :product_colors, :deleted_at
  end
end
