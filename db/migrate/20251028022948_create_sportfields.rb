class CreateSportfields < ActiveRecord::Migration[8.1]
  def change
    create_table :sportfields, id: :integer, primary_key: :sportfield_id do |t|
      t.string :name_vi, limit: 50
      t.string :name_en, limit: 50
      t.text :description_en
      t.text :description_vi

      t.timestamps
    end
  end
end
