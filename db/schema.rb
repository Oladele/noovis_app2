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

ActiveRecord::Schema.define(version: 20160120001841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.string   "name"
    t.decimal  "lat",             precision: 10, scale: 6
    t.decimal  "lng",             precision: 10, scale: 6
    t.integer  "network_site_id"
    t.text     "description"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "buildings", ["network_site_id"], name: "index_buildings_on_network_site_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "companies", ["name"], name: "index_companies_on_name", unique: true, using: :btree

  create_table "network_sites", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "address"
    t.integer  "company_id",                          null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.decimal  "lat",        precision: 10, scale: 6
    t.decimal  "lng",        precision: 10, scale: 6
  end

  add_index "network_sites", ["company_id", "name"], name: "index_network_sites_on_company_id_and_name", using: :btree
  add_index "network_sites", ["company_id"], name: "index_network_sites_on_company_id", using: :btree

  add_foreign_key "buildings", "network_sites"
  add_foreign_key "network_sites", "companies"
end
