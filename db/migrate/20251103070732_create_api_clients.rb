class CreateApiClients < ActiveRecord::Migration[8.1]
  def change
    create_table :api_clients do |t|
      t.string :name
      t.string :api_key

      t.timestamps
    end
  end
end
