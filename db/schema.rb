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

ActiveRecord::Schema[8.1].define(version: 2025_12_06_213536) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
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

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "albums", force: :cascade do |t|
    t.integer "author_id", null: false
    t.boolean "condition_is_new"
    t.datetime "created_at", null: false
    t.date "deleted_at"
    t.text "description"
    t.integer "genre_id", null: false
    t.string "media_type"
    t.string "name"
    t.integer "stock_available"
    t.decimal "unit_price"
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["author_id"], name: "index_albums_on_author_id"
    t.index ["genre_id"], name: "index_albums_on_genre_id"
  end

  create_table "audios", force: :cascade do |t|
    t.integer "album_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_audios_on_album_id"
  end

  create_table "authors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "full_name"
    t.datetime "updated_at", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer "album_id", null: false
    t.datetime "created_at", null: false
    t.boolean "is_cover"
    t.string "short_description"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_images_on_album_id"
  end

  create_table "sale_items", force: :cascade do |t|
    t.integer "album_id", null: false
    t.datetime "created_at", null: false
    t.decimal "price"
    t.string "product_name"
    t.integer "quantity"
    t.integer "sale_id", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_sale_items_on_album_id"
    t.index ["sale_id"], name: "index_sale_items_on_sale_id"
  end

  create_table "sales", force: :cascade do |t|
    t.string "buyer_contact"
    t.string "buyer_id"
    t.string "buyer_name"
    t.boolean "cancelled", default: false
    t.datetime "created_at", null: false
    t.datetime "sale_date"
    t.decimal "total"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "albums", "authors"
  add_foreign_key "albums", "genres"
  add_foreign_key "audios", "albums"
  add_foreign_key "images", "albums"
  add_foreign_key "sale_items", "albums"
  add_foreign_key "sale_items", "sales"
  add_foreign_key "sales", "users"
end
