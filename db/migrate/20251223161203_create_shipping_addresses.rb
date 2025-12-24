class CreateShippingAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :shipping_addresses do |t|
      t.integer :user_id, null: false

      t.string :receiver_name, null: false
      t.string :phone, null: false

      t.string :address_line, null: false
      t.string :ward, null: false
      t.string :city_province, null: false
      t.string :country, default: 'VN', null: false

      t.boolean :is_default, default: false, null: false

      t.timestamps
    end

    add_index :shipping_addresses, :user_id

    add_foreign_key :shipping_addresses, :users, column: :user_id, primary_key: :user_id
  end
end
