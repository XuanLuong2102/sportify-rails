class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.integer :user_id, null: false
      t.text :message
      t.boolean :is_read, default: false

      t.timestamps
    end

    add_foreign_key :notifications, :users, column: :user_id, primary_key: :user_id
  end
end
