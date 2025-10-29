class CreateFieldSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :field_schedules do |t|
      t.integer :place_sport_id, null: false
      t.date    :date
      t.integer :day_of_week, null: false, default: 0
      t.time    :start_time
      t.time    :end_time
      t.boolean :is_close, default: false
      t.boolean :is_available, default: true

      t.timestamps
    end

    add_foreign_key :field_schedules, :place_sports, column: :place_sport_id
  end
end
