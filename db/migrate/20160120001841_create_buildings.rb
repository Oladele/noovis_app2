class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :name
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lng, precision: 10, scale: 6
      t.references :network_site, index: true, foreign_key: true
      t.text :description

      t.timestamps null: false
    end
  end
end
