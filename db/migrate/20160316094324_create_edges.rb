class CreateEdges < ActiveRecord::Migration
  def change
    create_table :edges do |t|
      t.references :network_graph, index: true, foreign_key: true
      t.integer :to_node
      t.integer :from_node
      t.integer :level

      t.timestamps null: false
    end
  end
end
