class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.integer :user_id, null: false
      t.integer :place_sport_id, null: false
      t.bigint :schedule_id
      t.bigint :recurring_booking_id
      t.string  :status, limit: 50
      t.decimal :total_price, precision: 10, scale: 2

      t.timestamps
    end

    add_foreign_key :bookings, :users, column: :user_id, primary_key: :user_id
    add_foreign_key :bookings, :place_sports, column: :place_sport_id
    add_foreign_key :bookings, :recurring_bookings, column: :recurring_booking_id
    add_foreign_key :bookings, :field_schedules, column: :schedule_id
  end
end
