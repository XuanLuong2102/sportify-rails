class CreatePlaceSports < ActiveRecord::Migration[8.1]
  def change
    create_table :place_sports, id: :integer do |t|
      t.integer :place_id, null: false
      t.integer :sportfield_id, null: false
      t.boolean :maintenance_sport, default: false
      t.boolean :is_close, default: false
      t.decimal :price_per_hour_vnd, precision: 10, scale: 2
      t.decimal :price_per_hour_usd, precision: 10, scale: 2

      t.timestamps
    end

    add_foreign_key :place_sports, :places, column: :place_id, primary_key: :place_id
    add_foreign_key :place_sports, :sportfields, column: :sportfield_id, primary_key: :sportfield_id
  end
end
