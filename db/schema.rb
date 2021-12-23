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

ActiveRecord::Schema.define(version: 2021_12_23_130206) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "name", limit: 75
    t.string "location"
    t.text "description"
    t.integer "total_rating"
    t.decimal "member_cost", precision: 5, scale: 2
    t.decimal "guest_cost", precision: 5, scale: 2
    t.datetime "start_date", precision: 6
    t.datetime "end_date", precision: 6
    t.boolean "coffee_break"
    t.string "poster_file_name"
    t.string "poster_content_type"
    t.integer "poster_file_size"
    t.datetime "poster_updated_at", precision: 6
    t.integer "activity_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "allows_registrations", default: true
    t.string "external_link", default: ""
    t.integer "number_participants"
    t.string "speaker", limit: 75
    t.boolean "limit_number_participants"
    t.index ["activity_id"], name: "index_activities_on_activity_id"
  end

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 75
    t.text "text"
    t.string "poster_file_name"
    t.string "poster_content_type"
    t.integer "poster_file_size"
    t.datetime "poster_updated_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "job_taggings", force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "tag_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_id"], name: "index_job_taggings_on_job_id"
    t.index ["tag_id"], name: "index_job_taggings_on_tag_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "position"
    t.string "company"
    t.string "location"
    t.text "description"
    t.string "link"
    t.string "contact"
    t.string "poster_file_name"
    t.string "poster_content_type"
    t.integer "poster_file_size"
    t.datetime "poster_updated_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "members", id: :serial, force: :cascade do |t|
    t.integer "member_id"
    t.string "address"
    t.string "email"
    t.date "birthdate"
    t.string "course"
    t.boolean "paid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_number", default: ""
    t.string "student_id", default: ""
    t.boolean "is_buddy"
    t.boolean "admin", default: false, null: false
  end

  create_table "partners", id: :serial, force: :cascade do |t|
    t.string "name", limit: 75
    t.string "description"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at", precision: 6
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "registrations", id: :serial, force: :cascade do |t|
    t.integer "activity_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "confirmed", default: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 75
    t.string "phone_number", limit: 15, default: ""
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "provider"
    t.string "uid"
    t.string "oauth_token"
    t.datetime "oauth_expires_at", precision: 6
    t.string "image"
    t.integer "member_id"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "activities"
  add_foreign_key "job_taggings", "jobs"
  add_foreign_key "job_taggings", "tags"
  add_foreign_key "users", "members"
end
