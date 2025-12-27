class CreateSuppliers < ActiveRecord::Migration[8.1]
  def change
    create_table :suppliers do |t|
      t.string  :name, null: false
      t.string  :code, null: false
      t.string  :contact_name
      t.string  :phone
      t.string  :email
      t.string  :address
      t.text    :note
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end

    add_index :suppliers, :code, unique: true
    add_index :suppliers, :name
  end
end
