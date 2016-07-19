class CreateCableRuns < ActiveRecord::Migration
  def change
    create_table :cable_runs do |t|
      t.string :site
      t.string :building
      t.string :room
      t.string :drop
      t.string :rdt
      t.string :rdt_port
      t.string :fdh_port
      t.string :splitter
      t.string :splitter_fiber
      t.string :lgx_port
      t.string :fsan_sn
      t.references :sheet, index: true, foreign_key: true
      t.string :pon_card
      t.string :pon_port
      t.string :vam_smp
      t.string :fdh
      t.string :test_1310
      t.string :test_1550
      t.text :notes
      t.string :olt_rack
      t.string :olt_chassis
      t.string :vam_shelf
      t.string :vam_module
      t.string :vam_port
      t.string :backbone_shelf
      t.string :backbone_cable
      t.string :backbone_port
      t.string :fdh_location
      t.string :rdt_location
      t.string :ont_model
      t.string :ont_sn
      t.string :rdt_port_count
      t.string :ont_ge_1_device
      t.string :ont_ge_1_mac
      t.string :ont_ge_2_device
      t.string :ont_ge_2_mac
      t.string :ont_ge_3_device
      t.string :ont_ge_3_mac
      t.string :ont_ge_4_device
      t.string :ont_ge_4_mac

      t.timestamps null: false
    end
  end
end
