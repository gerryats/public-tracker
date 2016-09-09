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

ActiveRecord::Schema.define(version: 20160909123814) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "username",               limit: 255
    t.integer  "isadmin",                limit: 4,   default: 0
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "company_name",            limit: 255
    t.string   "trade_show_name",         limit: 255
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "comment",                 limit: 255
    t.string   "owner_email_id",          limit: 255
    t.string   "license",                 limit: 255
    t.datetime "License_creation_date"
    t.datetime "License_activation_date"
    t.datetime "License_renewed_date"
    t.integer  "License_valid_days",      limit: 4
    t.string   "License_state",           limit: 255, default: "deactivate"
    t.integer  "is_admin",                limit: 4,   default: 0
    t.integer  "cost",                    limit: 4
  end

  create_table "license_records", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.string   "license",    limit: 255
    t.integer  "cost",       limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "order_transactions", force: :cascade do |t|
    t.integer  "order_id",      limit: 4
    t.string   "action",        limit: 255
    t.integer  "amount",        limit: 4
    t.boolean  "success"
    t.string   "authorization", limit: 255
    t.string   "message",       limit: 255
    t.text     "params",        limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "new",             limit: 255
    t.integer  "cart_id",         limit: 4
    t.string   "ip_address",      limit: 255
    t.string   "first_name",      limit: 255
    t.string   "last_name",       limit: 255
    t.string   "card_brand",      limit: 255
    t.date     "card_expires"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.date     "card_expires_on"
    t.integer  "total_cost",      limit: 4
    t.integer  "total_days",      limit: 4
  end

  create_table "tradeshows", force: :cascade do |t|
    t.string   "trade_show_name", limit: 255
    t.integer  "company_id",      limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",       limit: 255
    t.string   "last_name",        limit: 255
    t.string   "email",            limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "image_url",        limit: 255
    t.string   "owner_email_id",   limit: 255
    t.integer  "trade_show_id",    limit: 4
    t.string   "username",         limit: 255
    t.string   "user_profile_pic", limit: 255
  end

  create_table "validlicenses", force: :cascade do |t|
    t.string   "generated_licenses", limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "owner_email",        limit: 255
  end

end
