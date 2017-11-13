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

ActiveRecord::Schema.define(version: 20171013085029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "name", limit: 75
    t.string "location"
    t.text "description"
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
    t.integer "department_id"
    t.boolean "allows_registrations", default: true
    t.string "external_link", default: ""
    t.index ["activity_id"], name: "index_activities_on_activity_id"
    t.index ["department_id"], name: "index_activities_on_department_id"
  end

  create_table "boards", id: :serial, force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", id: :serial, force: :cascade do |t|
    t.integer "member_id"
    t.string "address"
    t.string "email"
    t.date "birthdate"
    t.string "course"
    t.boolean "paid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_number", default: ""
    t.string "student_id", default: ""
    t.boolean "is_buddy"
    t.boolean "activity_admin", default: false, null: false
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.date "date"
    t.decimal "value", precision: 8, scale: 2
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registrations", id: :serial, force: :cascade do |t|
    t.integer "activity_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed", default: false
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "board_id"
    t.integer "department_id"
    t.integer "role_id"
    t.integer "user_id"
    t.index ["board_id"], name: "index_terms_on_board_id"
    t.index ["department_id"], name: "index_terms_on_department_id"
    t.index ["role_id"], name: "index_terms_on_role_id"
    t.index ["user_id"], name: "index_terms_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 75
    t.string "phone_number", limit: 15, default: ""
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "provider"
    t.string "uid"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.string "image"
    t.integer "member_id"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "activities", "activities"
  add_foreign_key "activities", "departments"
  add_foreign_key "users", "members"
end
