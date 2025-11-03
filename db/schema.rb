# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_10_28_023628) do
  create_table "bookings", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "place_sport_id", null: false
    t.bigint "recurring_booking_id"
    t.bigint "schedule_id"
    t.string "status", limit: 50
    t.decimal "total_price", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["place_sport_id"], name: "fk_rails_a5c035ee5f"
    t.index ["recurring_booking_id"], name: "fk_rails_4542c8ac6f"
    t.index ["schedule_id"], name: "fk_rails_ccde3eb122"
    t.index ["user_id"], name: "fk_rails_ef0571f117"
  end

  create_table "field_schedules", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.integer "day_of_week", default: 0, null: false
    t.time "end_time"
    t.boolean "is_available", default: true
    t.boolean "is_close", default: false
    t.integer "place_sport_id", null: false
    t.time "start_time"
    t.datetime "updated_at", null: false
    t.index ["place_sport_id"], name: "fk_rails_2068ee192b"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_read", default: false
    t.text "message_en"
    t.text "message_vi"
    t.string "title_en", limit: 50
    t.string "title_vi", limit: 50
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "fk_rails_b080fb4855"
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.bigint "booking_id"
    t.datetime "created_at", null: false
    t.string "currency", limit: 10
    t.datetime "paid_at"
    t.integer "payment_option", default: 0, null: false
    t.bigint "recurring_booking_id"
    t.string "status", limit: 50
    t.string "transaction_id"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["booking_id"], name: "fk_rails_6679f2064a"
    t.index ["recurring_booking_id"], name: "fk_rails_6aeb3f4926"
    t.index ["user_id"], name: "fk_rails_081dc04a02"
  end

  create_table "place_managers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "place_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["place_id"], name: "fk_rails_a2d4d6084e"
    t.index ["user_id", "place_id"], name: "index_place_managers_on_user_id_and_place_id", unique: true
  end

  create_table "place_sports", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_close", default: false
    t.boolean "maintenance_sport", default: false
    t.integer "place_id", null: false
    t.decimal "price_per_hour_usd", precision: 10, scale: 2
    t.decimal "price_per_hour_vnd", precision: 10, scale: 2
    t.integer "sportfield_id", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "fk_rails_0c10514a22"
    t.index ["sportfield_id"], name: "fk_rails_4b1df578f3"
  end

  create_table "places", primary_key: "place_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "address_en", limit: 100
    t.string "address_vi", limit: 100
    t.string "city_en", limit: 30
    t.string "city_vi", limit: 30
    t.time "close_time", default: "2000-01-01 21:00:00", null: false
    t.datetime "created_at", null: false
    t.text "description_en"
    t.text "description_vi"
    t.string "district_en", limit: 30
    t.string "district_vi", limit: 30
    t.boolean "is_close", default: false
    t.boolean "maintenance_place", default: false
    t.string "name_en", limit: 50
    t.string "name_vi", limit: 50
    t.time "open_time", default: "2000-01-01 08:00:00", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "content_en"
    t.text "content_vi"
    t.datetime "created_at", null: false
    t.string "image_url"
    t.string "title_en"
    t.string "title_vi"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "fk_rails_5b5ddfd518"
  end

  create_table "recurring_bookings", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "day_of_week", default: 0, null: false
    t.date "end_date"
    t.time "end_time"
    t.integer "place_sport_id", null: false
    t.integer "recurrence_type", default: 0, null: false
    t.date "start_date"
    t.time "start_time"
    t.string "status", limit: 50
    t.decimal "total_price", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "week_of_month"
    t.index ["place_sport_id"], name: "fk_rails_15ac5aff37"
    t.index ["user_id"], name: "fk_rails_db82455e9a"
  end

  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.integer "place_sport_id", null: false
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["place_sport_id"], name: "fk_rails_e83cb3ba1d"
    t.index ["user_id"], name: "fk_rails_74a66bd6c5"
  end

  create_table "roles", primary_key: "role_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", limit: 50, null: false
    t.datetime "updated_at", null: false
  end

  create_table "sportfields", primary_key: "sportfield_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description_en"
    t.text "description_vi"
    t.string "name_en", limit: 50
    t.string "name_vi", limit: 50
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "user_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", limit: 50, default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", limit: 30
    t.integer "gender", default: 0, null: false
    t.boolean "is_locked", default: false
    t.string "last_name", limit: 30
    t.string "middle_name", limit: 30
    t.string "phone", limit: 20
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role_id"
    t.datetime "updated_at", null: false
    t.string "username", limit: 30
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "bookings", "field_schedules", column: "schedule_id"
  add_foreign_key "bookings", "place_sports"
  add_foreign_key "bookings", "recurring_bookings"
  add_foreign_key "bookings", "users", primary_key: "user_id"
  add_foreign_key "field_schedules", "place_sports"
  add_foreign_key "notifications", "users", primary_key: "user_id"
  add_foreign_key "payments", "bookings"
  add_foreign_key "payments", "recurring_bookings"
  add_foreign_key "payments", "users", primary_key: "user_id"
  add_foreign_key "place_managers", "places", primary_key: "place_id"
  add_foreign_key "place_managers", "users", primary_key: "user_id"
  add_foreign_key "place_sports", "places", primary_key: "place_id"
  add_foreign_key "place_sports", "sportfields", primary_key: "sportfield_id"
  add_foreign_key "posts", "users", primary_key: "user_id"
  add_foreign_key "recurring_bookings", "place_sports"
  add_foreign_key "recurring_bookings", "users", primary_key: "user_id"
  add_foreign_key "reviews", "place_sports"
  add_foreign_key "reviews", "users", primary_key: "user_id"
  add_foreign_key "users", "roles", primary_key: "role_id"
end
