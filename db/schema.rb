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

ActiveRecord::Schema.define(version: 20160316115405) do

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
  end

  add_index "activities", ["activity_id"], name: "index_activities_on_activity_id"
  add_index "activities", ["department_id"], name: "index_activities_on_department_id"

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

  add_index "roles", ["department_id"], name: "index_roles_on_department_id"

  create_table "terms", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "account_number",     limit: 10
    t.string   "student_id",         limit: 10
    t.string   "name",               limit: 75
    t.string   "city",               limit: 30
    t.string   "phone_number",       limit: 15
    t.date     "birthdate"
    t.string   "type"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "email"
    t.string   "encrypted_password", limit: 128
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128
  end

  add_index "users", ["account_number"], name: "index_users_on_account_number", unique: true
  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"
  add_index "users", ["student_id"], name: "index_users_on_student_id", unique: true

end
