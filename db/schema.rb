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

ActiveRecord::Schema.define(version: 2019_08_20_102704) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dish_plans", force: :cascade do |t|
    t.bigint "dish_id"
    t.bigint "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_dish_plans_on_dish_id"
    t.index ["plan_id"], name: "index_dish_plans_on_plan_id"
  end

  create_table "dishes", force: :cascade do |t|
    t.string "name"
    t.bigint "kitchen_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.index ["kitchen_id"], name: "index_dishes_on_kitchen_id"
  end

  create_table "kitchens", force: :cascade do |t|
    t.string "name"
    t.string "photo"
    t.string "konbini"
    t.string "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_kitchens_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "label"
    t.text "address"
    t.float "latitude"
    t.float "longtitude"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "amount"
    t.bigint "user_id"
    t.bigint "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "request"
    t.string "date"
    t.index ["plan_id"], name: "index_orders_on_plan_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.bigint "kitchen_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.text "description"
    t.index ["kitchen_id"], name: "index_plans_on_kitchen_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin"
    t.string "photo"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "dish_plans", "dishes"
  add_foreign_key "dish_plans", "plans"
  add_foreign_key "dishes", "kitchens"
  add_foreign_key "kitchens", "users"
  add_foreign_key "locations", "users"
  add_foreign_key "orders", "plans"
  add_foreign_key "orders", "users"
  add_foreign_key "plans", "kitchens"
end
