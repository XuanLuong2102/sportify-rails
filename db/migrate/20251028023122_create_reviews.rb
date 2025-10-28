class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.integer :user_id, null: false
      t.integer :place_sport_id, null: false
      t.integer :rating
      t.text :comment

      t.timestamps
    end

    add_foreign_key :reviews, :users, column: :user_id, primary_key: :user_id
    add_foreign_key :reviews, :place_sports, column: :place_sport_id
  end
end
