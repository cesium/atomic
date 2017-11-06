# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180501000058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "name", limit: 75
    t.string "location"
    t.text "description"
    t.string "speaker", limit: 75
    t.integer "total_rating"
    t.decimal "member_cost", precision: 5, scale: 2
    t.decimal "guest_cost", precision: 5, scale: 2
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "coffee_break"
    t.string "poster_file_name"
    t.string "poster_content_type"
    t.integer "poster_file_size"
    t.datetime "poster_updated_at"
    t.integer "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "allows_registrations", default: true
    t.string "external_link", default: ""
    t.index ["activity_id"], name: "index_activities_on_activity_id"
  end

  create_table "identifiers", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.bigint "users_id"
    t.index ["users_id"], name: "index_identifiers_on_users_id"
  end

  create_table "partners", id: :serial, force: :cascade do |t|
    t.string "name", limit: 75
    t.string "description"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registrations", id: :serial, force: :cascade do |t|
    t.integer "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed", default: false
    t.bigint "users_id"
    t.index ["users_id"], name: "index_registrations_on_users_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "course"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cesium_id", default: ""
    t.string "student_id", default: ""
    t.boolean "activity_admin", default: false, null: false
    t.string "phone_number", limit: 15, default: ""
    t.string "name", limit: 75, null: false
    t.string "hashname", null: false
    t.string "image"
  end

  add_foreign_key "activities", "activities"
end
