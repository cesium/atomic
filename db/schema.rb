# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170220151120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "name",                limit: 75
    t.string   "location"
    t.text     "description"
    t.integer  "total_rating"
    t.decimal  "member_cost",                    precision: 5, scale: 2
    t.decimal  "guest_cost",                     precision: 5, scale: 2
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "coffee_break"
    t.string   "poster_file_name"
    t.string   "poster_content_type"
    t.integer  "poster_file_size"
    t.datetime "poster_updated_at"
    t.integer  "activity_id"
    t.integer  "department_id"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "registration_link"
  end

  add_index "activities", ["activity_id"], name: "index_activities_on_activity_id", using: :btree
  add_index "activities", ["department_id"], name: "index_activities_on_department_id", using: :btree

  create_table "boards", force: :cascade do |t|
    t.integer  "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.date     "date"
    t.decimal  "value",      precision: 8, scale: 2
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "activity_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "title"
    t.integer  "department_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "roles", ["department_id"], name: "index_roles_on_department_id", using: :btree

  create_table "terms", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "account_number",   limit: 10, default: ""
    t.string   "student_id",       limit: 10
    t.string   "name",             limit: 75
    t.string   "city",             limit: 30
    t.string   "phone_number",     limit: 15, default: ""
    t.string   "user_type"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "email"
    t.boolean  "admin",                       default: false, null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "image"
  end

  add_index "users", ["account_number"], name: "index_users_on_account_number", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["student_id"], name: "index_users_on_student_id", unique: true, using: :btree

end
