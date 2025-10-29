class CreateSportfields < ActiveRecord::Migration[8.1]
  def change
    create_table :sportfields, id: :integer, primary_key: :sportfield_id do |t|
      t.string :name, limit: 255
      t.string :sport_type, limit: 100
      t.decimal :price_per_hour, precision: 10, scale: 2

      t.timestamps
    end
  end
end
