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

ActiveRecord::Schema.define(version: 2018_09_25_131223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_customers_on_account_id"
  end

  create_table "invites", force: :cascade do |t|
    t.string "email"
    t.string "state"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "seller_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seller_id"], name: "index_orders_on_seller_id"
    t.index ["shop_id"], name: "index_orders_on_shop_id"
  end

  create_table "orders_products", id: false, force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.index ["order_id", "product_id"], name: "index_orders_products_on_order_id_and_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "shop_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_products_on_shop_id"
  end

  create_table "sellers", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "role"
    t.index ["account_id"], name: "index_sellers_on_account_id"
    t.index ["confirmation_token"], name: "index_sellers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_sellers_on_email", unique: true
    t.index ["invitation_token"], name: "index_sellers_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_sellers_on_invitations_count"
    t.index ["invited_by_id"], name: "index_sellers_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_sellers_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_sellers_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_sellers_on_uid_and_provider", unique: true
  end

  create_table "sellers_shops", id: false, force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.bigint "seller_id", null: false
    t.index ["seller_id", "shop_id"], name: "index_sellers_shops_on_seller_id_and_shop_id"
    t.index ["shop_id", "seller_id"], name: "index_sellers_shops_on_shop_id_and_seller_id"
  end

  create_table "shops", force: :cascade do |t|
    t.bigint "account_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_shops_on_account_id"
  end

  add_foreign_key "customers", "accounts"
  add_foreign_key "orders", "sellers"
  add_foreign_key "orders", "shops"
  add_foreign_key "products", "shops"
  add_foreign_key "sellers", "accounts"
  add_foreign_key "shops", "accounts"
end
