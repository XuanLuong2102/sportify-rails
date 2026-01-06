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

ActiveRecord::Schema[8.1].define(version: 2026_01_06_163623) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "api_clients", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "api_key"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

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

  create_table "expenses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.decimal "amount_usd", precision: 12, scale: 2, null: false
    t.decimal "amount_vnd", precision: 12, scale: 2, null: false
    t.datetime "created_at", null: false
    t.date "expense_date", null: false
    t.integer "expense_type", null: false
    t.text "note"
    t.integer "owner_id"
    t.integer "owner_type", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_date"], name: "index_expenses_on_expense_date"
    t.index ["expense_type"], name: "index_expenses_on_expense_type"
    t.index ["owner_type", "owner_id"], name: "index_expenses_on_owner_type_and_owner_id"
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

  create_table "order_items", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.string "product_name", null: false
    t.bigint "product_variant_id"
    t.integer "quantity", default: 1, null: false
    t.decimal "total_price_usd", precision: 10, scale: 2, null: false
    t.decimal "total_price_vnd", precision: 10, scale: 2, null: false
    t.decimal "unit_price_usd", precision: 10, scale: 2, null: false
    t.decimal "unit_price_vnd", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.string "variant_name"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
    t.index ["product_variant_id"], name: "index_order_items_on_product_variant_id"
  end

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.string "order_code", null: false
    t.datetime "ordered_at"
    t.datetime "paid_at"
    t.integer "place_id", null: false
    t.text "shipping_address", null: false
    t.decimal "shipping_fee_usd", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "shipping_fee_vnd", precision: 10, scale: 2, default: "0.0", null: false
    t.string "shipping_phone", null: false
    t.string "shipping_receiver_name", null: false
    t.string "status", limit: 50, default: "pending", null: false
    t.decimal "subtotal_amount_usd", precision: 10, scale: 2, null: false
    t.decimal "subtotal_amount_vnd", precision: 10, scale: 2, null: false
    t.decimal "total_amount_usd", precision: 10, scale: 2, null: false
    t.decimal "total_amount_vnd", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["order_code"], name: "index_orders_on_order_code", unique: true
    t.index ["place_id"], name: "index_orders_on_place_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.bigint "booking_id"
    t.datetime "created_at", null: false
    t.string "currency", limit: 10
    t.bigint "order_id"
    t.datetime "paid_at"
    t.integer "payment_option", default: 0, null: false
    t.bigint "recurring_booking_id"
    t.string "status", limit: 50
    t.string "transaction_id"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["booking_id"], name: "fk_rails_6679f2064a"
    t.index ["order_id"], name: "index_payments_on_order_id"
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

  create_table "product_brands", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_categories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description_en"
    t.text "description_vi"
    t.string "name_en", null: false
    t.string "name_vi", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_colors", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "code_rgb"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "code_rgb"], name: "index_product_colors_on_name_and_code_rgb", unique: true
  end

  create_table "product_images", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "image_url"
    t.bigint "product_color_id"
    t.bigint "product_id", null: false
    t.integer "sort_order", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "view_type"
    t.index ["product_color_id"], name: "index_product_images_on_product_color_id"
    t.index ["product_id", "image_url"], name: "idx_unique_product_image", unique: true
    t.index ["product_id", "product_color_id", "image_url"], name: "idx_unique_color_image", unique: true
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "product_listings", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true
    t.integer "place_id", null: false
    t.bigint "product_id", null: false
    t.integer "sold_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["place_id", "product_id"], name: "index_product_listings_on_place_id_and_product_id", unique: true
    t.index ["product_id"], name: "fk_rails_d55070d4ef"
  end

  create_table "product_reviews", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.bigint "product_listing_id", null: false
    t.integer "rating", default: 5, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["product_listing_id"], name: "index_product_reviews_on_product_listing_id"
    t.index ["user_id"], name: "index_product_reviews_on_user_id"
    t.check_constraint "`rating` between 1 and 5"
  end

  create_table "product_sizes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_stocks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_listing_id", null: false
    t.bigint "product_variant_id", null: false
    t.integer "stock_quantity", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["product_listing_id", "product_variant_id"], name: "idx_on_product_listing_id_product_variant_id_fa8f706a6d", unique: true
    t.index ["product_variant_id"], name: "fk_rails_4afa31fea2"
  end

  create_table "product_variants", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true
    t.decimal "price_usd", precision: 10, scale: 2
    t.decimal "price_vnd", precision: 10, scale: 2, null: false
    t.bigint "product_color_id"
    t.bigint "product_id", null: false
    t.bigint "product_size_id"
    t.string "sku"
    t.datetime "updated_at", null: false
    t.index ["product_color_id"], name: "index_product_variants_on_product_color_id"
    t.index ["product_id", "product_color_id", "product_size_id"], name: "idx_on_product_id_product_color_id_product_size_id_904c79a58a", unique: true
    t.index ["product_id"], name: "index_product_variants_on_product_id"
    t.index ["product_size_id"], name: "index_product_variants_on_product_size_id"
    t.index ["sku"], name: "index_product_variants_on_sku", unique: true
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "brand_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.text "description_en"
    t.text "description_vi"
    t.boolean "is_active", default: true
    t.string "name_en", null: false
    t.string "name_vi", null: false
    t.string "thumbnail_url"
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["category_id"], name: "index_products_on_category_id"
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

  create_table "shipping_addresses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "address_line", null: false
    t.string "city_province", null: false
    t.string "country", default: "VN", null: false
    t.datetime "created_at", null: false
    t.boolean "is_default", default: false, null: false
    t.string "phone", null: false
    t.string "receiver_name", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "ward", null: false
    t.index ["user_id"], name: "index_shipping_addresses_on_user_id"
  end

  create_table "sportfields", primary_key: "sportfield_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description_en"
    t.text "description_vi"
    t.string "name_en", limit: 50
    t.string "name_vi", limit: 50
    t.datetime "updated_at", null: false
  end

  create_table "stock_inbounds", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.decimal "cost_price_usd", precision: 10, scale: 2
    t.decimal "cost_price_vnd", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.bigint "product_variant_id", null: false
    t.integer "quantity", null: false
    t.datetime "received_at", null: false
    t.string "reference_code"
    t.bigint "supplier_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "warehouse_id", null: false
    t.index ["product_variant_id"], name: "index_stock_inbounds_on_product_variant_id"
    t.index ["received_at"], name: "index_stock_inbounds_on_received_at"
    t.index ["supplier_id"], name: "index_stock_inbounds_on_supplier_id"
    t.index ["warehouse_id"], name: "index_stock_inbounds_on_warehouse_id"
  end

  create_table "stock_request_items", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_variant_id", null: false
    t.integer "requested_quantity", null: false
    t.bigint "stock_request_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_variant_id"], name: "index_stock_request_items_on_product_variant_id"
    t.index ["stock_request_id", "product_variant_id"], name: "idx_unique_request_variant", unique: true
    t.index ["stock_request_id"], name: "index_stock_request_items_on_stock_request_id"
  end

  create_table "stock_requests", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "approved_at"
    t.integer "approved_by_id"
    t.datetime "created_at", null: false
    t.text "note"
    t.integer "place_id", null: false
    t.datetime "rejected_at"
    t.integer "requested_by_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_stock_requests_on_approved_by_id"
    t.index ["place_id"], name: "index_stock_requests_on_place_id"
    t.index ["requested_by_id"], name: "index_stock_requests_on_requested_by_id"
  end

  create_table "stock_transfers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "note"
    t.integer "place_id", null: false
    t.bigint "product_variant_id", null: false
    t.integer "quantity", null: false
    t.bigint "stock_request_id", null: false
    t.datetime "transferred_at", null: false
    t.integer "transferred_by_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "warehouse_id", null: false
    t.index ["place_id"], name: "index_stock_transfers_on_place_id"
    t.index ["product_variant_id"], name: "index_stock_transfers_on_product_variant_id"
    t.index ["stock_request_id"], name: "index_stock_transfers_on_stock_request_id"
    t.index ["transferred_at"], name: "index_stock_transfers_on_transferred_at"
    t.index ["transferred_by_id"], name: "index_stock_transfers_on_transferred_by_id"
    t.index ["warehouse_id"], name: "index_stock_transfers_on_warehouse_id"
  end

  create_table "suppliers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "address"
    t.string "code", null: false
    t.string "contact_name"
    t.datetime "created_at", null: false
    t.string "email"
    t.boolean "is_active", default: true, null: false
    t.string "name", null: false
    t.text "note"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_suppliers_on_code", unique: true
    t.index ["name"], name: "index_suppliers_on_name"
  end

  create_table "users", primary_key: "user_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.date "birthday"
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

  create_table "warehouse_stocks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_variant_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "warehouse_id", null: false
    t.index ["product_variant_id"], name: "index_warehouse_stocks_on_product_variant_id"
    t.index ["warehouse_id", "product_variant_id"], name: "idx_unique_warehouse_variant", unique: true
    t.index ["warehouse_id"], name: "index_warehouse_stocks_on_warehouse_id"
  end

  create_table "warehouses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "location"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_warehouses_on_code", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "field_schedules", column: "schedule_id"
  add_foreign_key "bookings", "place_sports"
  add_foreign_key "bookings", "recurring_bookings"
  add_foreign_key "bookings", "users", primary_key: "user_id"
  add_foreign_key "field_schedules", "place_sports"
  add_foreign_key "notifications", "users", primary_key: "user_id"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "product_variants"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "places", primary_key: "place_id"
  add_foreign_key "orders", "users", primary_key: "user_id"
  add_foreign_key "payments", "bookings"
  add_foreign_key "payments", "orders"
  add_foreign_key "payments", "recurring_bookings"
  add_foreign_key "payments", "users", primary_key: "user_id"
  add_foreign_key "place_managers", "places", primary_key: "place_id"
  add_foreign_key "place_managers", "users", primary_key: "user_id"
  add_foreign_key "place_sports", "places", primary_key: "place_id"
  add_foreign_key "place_sports", "sportfields", primary_key: "sportfield_id"
  add_foreign_key "posts", "users", primary_key: "user_id"
  add_foreign_key "product_images", "product_colors"
  add_foreign_key "product_images", "products"
  add_foreign_key "product_listings", "places", primary_key: "place_id"
  add_foreign_key "product_listings", "products"
  add_foreign_key "product_reviews", "product_listings"
  add_foreign_key "product_reviews", "users", primary_key: "user_id"
  add_foreign_key "product_stocks", "product_listings"
  add_foreign_key "product_stocks", "product_variants"
  add_foreign_key "product_variants", "product_colors"
  add_foreign_key "product_variants", "product_sizes"
  add_foreign_key "product_variants", "products"
  add_foreign_key "products", "product_brands", column: "brand_id"
  add_foreign_key "products", "product_categories", column: "category_id"
  add_foreign_key "recurring_bookings", "place_sports"
  add_foreign_key "recurring_bookings", "users", primary_key: "user_id"
  add_foreign_key "reviews", "place_sports"
  add_foreign_key "reviews", "users", primary_key: "user_id"
  add_foreign_key "shipping_addresses", "users", primary_key: "user_id"
  add_foreign_key "stock_inbounds", "product_variants"
  add_foreign_key "stock_inbounds", "suppliers"
  add_foreign_key "stock_inbounds", "warehouses"
  add_foreign_key "stock_request_items", "product_variants"
  add_foreign_key "stock_request_items", "stock_requests"
  add_foreign_key "stock_requests", "places", primary_key: "place_id"
  add_foreign_key "stock_requests", "users", column: "approved_by_id", primary_key: "user_id"
  add_foreign_key "stock_requests", "users", column: "requested_by_id", primary_key: "user_id"
  add_foreign_key "stock_transfers", "places", primary_key: "place_id"
  add_foreign_key "stock_transfers", "product_variants"
  add_foreign_key "stock_transfers", "stock_requests"
  add_foreign_key "stock_transfers", "users", column: "transferred_by_id", primary_key: "user_id"
  add_foreign_key "stock_transfers", "warehouses"
  add_foreign_key "users", "roles", primary_key: "role_id"
  add_foreign_key "warehouse_stocks", "product_variants"
  add_foreign_key "warehouse_stocks", "warehouses"
end
