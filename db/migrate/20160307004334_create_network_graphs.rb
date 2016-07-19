class CreateNetworkGraphs < ActiveRecord::Migration
  def change
    create_table :network_graphs do |t|
      t.references :sheet, index: true, foreign_key: true
      t.references :network_template, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
