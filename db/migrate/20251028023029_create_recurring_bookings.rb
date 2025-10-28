class CreateRecurringBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :recurring_bookings do |t|
      t.integer :user_id, null: false
      t.integer :place_sport_id, null: false
      t.date    :start_date
      t.date    :end_date
      t.integer :recurrence_type, null: false, default: 0
      t.integer :day_of_week, null: false, default: 0
      t.integer :week_of_month
      t.time    :start_time
      t.time    :end_time
      t.decimal :total_price, precision: 10, scale: 2
      t.string  :status, limit: 50

      t.timestamps
    end

    add_foreign_key :recurring_bookings, :users, column: :user_id, primary_key: :user_id
    add_foreign_key :recurring_bookings, :place_sports, column: :place_sport_id
  end
end
