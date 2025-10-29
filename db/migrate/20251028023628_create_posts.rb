class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.string :title, limit: 255
      t.text   :content
      t.string :image_url, limit: 255

      t.timestamps
    end

    add_foreign_key :posts, :users, column: :user_id, primary_key: :user_id
  end
end
