class CreatePlaces < ActiveRecord::Migration[8.1]
  def change
    create_table :places, id: :integer, primary_key: :place_id do |t|
      t.string :name_en, limit: 50
      t.string :name_vi, limit: 50
      t.string :address_en, limit: 100
      t.string :address_vi, limit: 100
      t.string :district_en, limit: 30
      t.string :district_vi, limit: 30
      t.string :city_en, limit: 30
      t.string :city_vi, limit: 30
      t.text :description_en
      t.text :description_vi
      t.boolean :maintenance_place, default: false
      t.boolean :is_close, default: false

      t.timestamps
    end
  end
end
