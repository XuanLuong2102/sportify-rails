class CreateRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :roles, id: :integer, primary_key: :role_id do |t|
      t.string :name, limit: 50, null: false
      t.timestamps
    end
  end
end
