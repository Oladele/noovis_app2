class CreateTestNetworkGraphs < ActiveRecord::Migration
  def change
    create_table :test_network_graphs do |t|
      t.references :building, index: true, foreign_key: true
      t.json :graph

      t.timestamps null: false
    end
  end
end
