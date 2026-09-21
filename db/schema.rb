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

ActiveRecord::Schema[8.1].define(version: 2026_09_21_121922) do
  create_table "check_ins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "ends_at", null: false
    t.integer "place_id", null: false
    t.datetime "started_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["place_id", "ends_at"], name: "index_check_ins_on_place_id_and_ends_at"
    t.index ["place_id"], name: "index_check_ins_on_place_id"
    t.index ["user_id", "place_id"], name: "index_check_ins_on_user_id_and_place_id"
    t.index ["user_id"], name: "index_check_ins_on_user_id"
    t.check_constraint "ends_at > started_at", name: "check_ins_ends_after_start"
  end

  create_table "places", force: :cascade do |t|
    t.boolean "approved", default: false, null: false
    t.integer "capacity", null: false
    t.integer "category", default: 0, null: false
    t.datetime "created_at", null: false
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.datetime "locked_at"
    t.integer "locked_by_id"
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.string "name", null: false
    t.string "opening_hours"
    t.integer "proposed_by_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_places_on_approved"
    t.index ["category"], name: "index_places_on_category"
    t.index ["status"], name: "index_places_on_status"
    t.check_constraint "capacity > 0", name: "places_capacity_positive"
  end

  create_table "status_reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "place_id", null: false
    t.integer "reported_status", null: false
    t.boolean "reviewed", default: false, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["place_id", "reviewed"], name: "index_status_reports_on_place_id_and_reviewed"
    t.index ["place_id"], name: "index_status_reports_on_place_id"
    t.index ["reviewed"], name: "index_status_reports_on_reviewed"
    t.index ["user_id"], name: "index_status_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "confirmation_token"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.boolean "locked", default: false, null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "check_ins", "places"
  add_foreign_key "check_ins", "users"
  add_foreign_key "places", "users", column: "locked_by_id"
  add_foreign_key "places", "users", column: "proposed_by_id"
  add_foreign_key "status_reports", "places"
  add_foreign_key "status_reports", "users"
end
