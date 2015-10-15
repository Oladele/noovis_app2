class CreateNetworkSites < ActiveRecord::Migration
  def change
    create_table :network_sites do |t|
      t.string :name
      t.string :address
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :network_sites, [:company_id, :name]
  end
end
