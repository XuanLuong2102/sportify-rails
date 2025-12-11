class CreateProductReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :product_reviews do |t|
      t.integer  :user_id, null: false
      t.bigint   :product_listing_id, null: false
      t.integer  :rating, null: false, default: 5
      t.text     :comment
      t.timestamps
    end

    add_index :product_reviews, :user_id
    add_index :product_reviews, :product_listing_id

    add_foreign_key :product_reviews, :users, column: :user_id, primary_key: :user_id
    add_foreign_key :product_reviews, :product_listings, column: :product_listing_id

    add_check_constraint :product_reviews, 'rating BETWEEN 1 AND 5'
  end
end
