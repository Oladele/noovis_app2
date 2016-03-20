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

ActiveRecord::Schema.define(version: 20160317213903) do

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
  end

  add_index "cable_runs", ["sheet_id"], name: "index_cable_runs_on_sheet_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "companies", ["name"], name: "index_companies_on_name", unique: true, using: :btree

  create_table "edges", force: :cascade do |t|
    t.integer  "network_graph_id"
    t.integer  "to_node_id"
    t.integer  "from_node_id"
    t.integer  "edge_level"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "level"
    t.integer  "to"
    t.integer  "from"
  end

  add_index "edges", ["network_graph_id"], name: "index_edges_on_network_graph_id", using: :btree

  create_table "network_graphs", force: :cascade do |t|
    t.integer  "sheet_id"
    t.integer  "network_template_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
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

  create_table "nodes", force: :cascade do |t|
    t.integer  "network_graph_id"
    t.string   "node_value"
    t.integer  "node_level"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "parent_id"
    t.integer  "cable_run_id"
    t.string   "node_type"
    t.string   "label"
    t.string   "level"
  end

  add_index "nodes", ["cable_run_id"], name: "index_nodes_on_cable_run_id", using: :btree
  add_index "nodes", ["network_graph_id"], name: "index_nodes_on_network_graph_id", using: :btree
  add_index "nodes", ["parent_id"], name: "index_nodes_on_parent_id", using: :btree

  create_table "sheets", force: :cascade do |t|
    t.string   "name"
    t.integer  "workbook_id"
    t.integer  "building_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "sheets", ["building_id"], name: "index_sheets_on_building_id", using: :btree
  add_index "sheets", ["workbook_id"], name: "index_sheets_on_workbook_id", using: :btree

  create_table "workbooks", force: :cascade do |t|
    t.string   "name"
    t.integer  "network_site_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "workbooks", ["network_site_id"], name: "index_workbooks_on_network_site_id", using: :btree

  add_foreign_key "buildings", "network_sites"
  add_foreign_key "cable_runs", "sheets"
  add_foreign_key "edges", "network_graphs"
  add_foreign_key "network_graphs", "network_templates"
  add_foreign_key "network_graphs", "sheets"
  add_foreign_key "network_sites", "companies"
  add_foreign_key "nodes", "network_graphs"
  add_foreign_key "sheets", "buildings"
  add_foreign_key "sheets", "workbooks"
  add_foreign_key "workbooks", "network_sites"
end
