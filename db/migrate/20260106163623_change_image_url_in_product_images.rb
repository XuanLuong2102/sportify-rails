class ChangeImageUrlInProductImages < ActiveRecord::Migration[8.1]
  def change
    change_column_null :product_images, :image_url, true
  end
end
