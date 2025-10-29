class CreatePlaces < ActiveRecord::Migration[8.1]
  def change
    create_table :places, id: :integer, primary_key: :place_id do |t|
      t.string :name, limit: 50
      t.string :address, limit: 100
      t.string :district, limit: 20
      t.string :city, limit: 20
      t.boolean :maintenance_place, default: false
      t.boolean :is_close, default: false

      t.timestamps
    end
  end
end
