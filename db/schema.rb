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

ActiveRecord::Schema.define(version: 2019_08_30_001623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chat_rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.index ["order_id"], name: "index_chat_rooms_on_order_id"
  end

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
    t.integer "calories"
    t.integer "fat"
    t.integer "carbs"
    t.integer "protein"
    t.index ["kitchen_id"], name: "index_dishes_on_kitchen_id"
  end

  create_table "kitchens", force: :cascade do |t|
    t.string "name"
    t.string "photo"
    t.string "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "konbini_id"
    t.string "video"
    t.index ["konbini_id"], name: "index_kitchens_on_konbini_id"
    t.index ["user_id"], name: "index_kitchens_on_user_id"
  end

  create_table "konbinis", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.float "longitude"
    t.float "latitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mapbox_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "label"
    t.text "address"
    t.float "latitude"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "longitude"
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.bigint "chat_room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_room_id"], name: "index_messages_on_chat_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "amount_cents", default: 0, null: false
    t.jsonb "payment"
    t.bigint "user_id"
    t.bigint "plan_id"
    t.string "plan_sku"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "pending"
    t.text "request", default: "no request"
    t.string "date"
    t.index ["plan_id"], name: "index_orders_on_plan_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.bigint "kitchen_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.text "description"
    t.integer "price_cents", default: 0, null: false
    t.index ["kitchen_id"], name: "index_plans_on_kitchen_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "content"
    t.integer "rating"
    t.bigint "user_id"
    t.bigint "kitchen_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kitchen_id"], name: "index_reviews_on_kitchen_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
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
    t.text "preference", default: "no preference"
    t.string "photo", default: "https://res.cloudinary.com/dxouryvao/image/upload/v1566699442/bento_ylouzo.png"
    t.integer "default_location"
    t.integer "radius"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chat_rooms", "orders"
  add_foreign_key "dish_plans", "dishes"
  add_foreign_key "dish_plans", "plans"
  add_foreign_key "dishes", "kitchens"
  add_foreign_key "kitchens", "konbinis"
  add_foreign_key "kitchens", "users"
  add_foreign_key "locations", "users"
  add_foreign_key "messages", "chat_rooms"
  add_foreign_key "messages", "users"
  add_foreign_key "orders", "plans"
  add_foreign_key "orders", "users"
  add_foreign_key "plans", "kitchens"
  add_foreign_key "reviews", "kitchens"
  add_foreign_key "reviews", "users"
end
