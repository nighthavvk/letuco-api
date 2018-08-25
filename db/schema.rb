# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_180_821_070_902) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'accounts', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'customers', force: :cascade do |t|
    t.bigint 'account_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_id'], name: 'index_customers_on_account_id'
  end

  create_table 'orders', force: :cascade do |t|
    t.bigint 'shop_id'
    t.bigint 'seller_id'
    t.string 'status'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['seller_id'], name: 'index_orders_on_seller_id'
    t.index ['shop_id'], name: 'index_orders_on_shop_id'
  end

  create_table 'orders_products', id: false, force: :cascade do |t|
    t.bigint 'order_id', null: false
    t.bigint 'product_id', null: false
    t.index %w[order_id product_id], name: 'index_orders_products_on_order_id_and_product_id'
  end

  create_table 'products', force: :cascade do |t|
    t.bigint 'shop_id'
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['shop_id'], name: 'index_products_on_shop_id'
  end

  create_table 'sellers', force: :cascade do |t|
    t.bigint 'account_id'
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_id'], name: 'index_sellers_on_account_id'
  end

  create_table 'shops', force: :cascade do |t|
    t.bigint 'account_id'
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['account_id'], name: 'index_shops_on_account_id'
  end

  add_foreign_key 'customers', 'accounts'
  add_foreign_key 'orders', 'sellers'
  add_foreign_key 'orders', 'shops'
  add_foreign_key 'products', 'shops'
  add_foreign_key 'sellers', 'accounts'
  add_foreign_key 'shops', 'accounts'
end
