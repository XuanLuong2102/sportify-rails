class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.integer :owner_type, null: false
      t.integer :owner_id

      t.integer :expense_type, null: false
      t.decimal :amount_vnd, precision: 12, scale: 2, null: false
      t.decimal :amount_usd, precision: 12, scale: 2, null: false

      t.string :title, null: false
      t.text :note

      t.date :expense_date, null: false
      t.timestamps
    end

    add_index :expenses, [:owner_type, :owner_id]
    add_index :expenses, :expense_date
    add_index :expenses, :expense_type
  end
end
