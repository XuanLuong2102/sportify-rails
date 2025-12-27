class CreateStockRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_requests do |t|
      t.references :place,
                   type: :integer,
                   null: false,
                   foreign_key: { to_table: :places, primary_key: :place_id }

      t.integer :status, null: false, default: 0
      t.text :note

      t.references :requested_by,
                   type: :integer,
                   null: false,
                   foreign_key: { to_table: :users, primary_key: :user_id }

      t.references :approved_by,
                   type: :integer,
                   foreign_key: { to_table: :users, primary_key: :user_id }

      t.datetime :approved_at
      t.datetime :rejected_at

      t.timestamps
    end
  end
end
