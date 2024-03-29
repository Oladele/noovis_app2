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

ActiveRecord::Schema.define(version: 20160725162723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

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

  create_table "cable_runs", force: :cascade do |t|
    t.string   "site"
    t.string   "building"
    t.string   "room"
    t.string   "drop"
    t.string   "rdt"
    t.string   "rdt_port"
    t.string   "fdh_port"
    t.string   "splitter"
    t.string   "splitter_fiber"
    t.integer  "sheet_id"
    t.string   "pon_card"
    t.string   "pon_port"
    t.string   "fdh"
    t.text     "notes"
    t.string   "olt_rack"
    t.string   "olt_chassis"
    t.string   "vam_shelf"
    t.string   "vam_module"
    t.string   "vam_port"
    t.string   "backbone_shelf"
    t.string   "backbone_cable"
    t.string   "backbone_port"
    t.string   "fdh_location"
    t.string   "rdt_location"
    t.string   "ont_model"
    t.string   "ont_sn"
    t.string   "rdt_port_count"
    t.string   "ont_ge_1_device"
    t.string   "ont_ge_1_mac"
    t.string   "ont_ge_2_device"
    t.string   "ont_ge_2_mac"
    t.string   "ont_ge_3_device"
    t.string   "ont_ge_3_mac"
    t.string   "ont_ge_4_device"
    t.string   "ont_ge_4_mac"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "floor"
  end

  add_index "cable_runs", ["sheet_id"], name: "index_cable_runs_on_sheet_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "companies", ["name"], name: "index_companies_on_name", unique: true, using: :btree

  create_table "import_jobs", force: :cascade do |t|
    t.integer  "building_id"
    t.string   "status"
    t.string   "filename"
    t.string   "sheet_name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "spreadsheet_file_name"
    t.string   "spreadsheet_content_type"
    t.integer  "spreadsheet_file_size"
    t.datetime "spreadsheet_updated_at"
    t.string   "message"
  end

  create_table "network_graphs", force: :cascade do |t|
    t.integer  "sheet_id"
    t.integer  "network_template_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.json     "graph"
    t.json     "nodes"
    t.json     "edges"
    t.json     "node_counts"
  end

  add_index "network_graphs", ["network_template_id"], name: "index_network_graphs_on_network_template_id", using: :btree
  add_index "network_graphs", ["sheet_id"], name: "index_network_graphs_on_sheet_id", using: :btree

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

  create_table "network_templates", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "hierarchy",   default: [],              array: true
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "network_templates", ["hierarchy"], name: "index_network_templates_on_hierarchy", using: :gin

  create_table "node_types", force: :cascade do |t|
    t.string   "name"
    t.string   "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sheets", force: :cascade do |t|
    t.string   "name"
    t.integer  "workbook_id"
    t.integer  "building_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "sheets", ["building_id"], name: "index_sheets_on_building_id", using: :btree
  add_index "sheets", ["workbook_id"], name: "index_sheets_on_workbook_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.integer  "company_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.json     "tokens"
    t.integer  "role"
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "sheet_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "workbooks", force: :cascade do |t|
    t.string   "name"
    t.integer  "network_site_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "workbooks", ["network_site_id"], name: "index_workbooks_on_network_site_id", using: :btree

  add_foreign_key "buildings", "network_sites"
  add_foreign_key "cable_runs", "sheets"
  add_foreign_key "network_graphs", "network_templates"
  add_foreign_key "network_graphs", "sheets"
  add_foreign_key "network_sites", "companies"
  add_foreign_key "sheets", "buildings"
  add_foreign_key "sheets", "workbooks"
  add_foreign_key "users", "companies"
  add_foreign_key "workbooks", "network_sites"
end
