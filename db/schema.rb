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

  create_table "boards", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
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

  create_table "roles", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "board_id"
    t.integer  "department_id"
    t.integer  "role_id"
    t.integer  "user_id"
  end

  add_index "terms", ["board_id"], name: "index_terms_on_board_id"
  add_index "terms", ["department_id"], name: "index_terms_on_department_id"
  add_index "terms", ["role_id"], name: "index_terms_on_role_id"
  add_index "terms", ["user_id"], name: "index_terms_on_user_id"

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
