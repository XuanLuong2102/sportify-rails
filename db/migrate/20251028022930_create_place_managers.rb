class CreatePlaceManagers < ActiveRecord::Migration[8.1]
  def change
     create_table :place_managers do |t|
      t.integer :user_id, null: false
      t.integer :place_id, null: false

      t.timestamps
    end

    add_index :place_managers, [:user_id, :place_id], unique: true
    add_foreign_key :place_managers, :users, column: :user_id, primary_key: :user_id
    add_foreign_key :place_managers, :places, column: :place_id, primary_key: :place_id
  end
end
