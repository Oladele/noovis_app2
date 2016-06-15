class DropNodesAndEdgesTables < ActiveRecord::Migration
  def change
    drop_table :nodes
    drop_table :edges
  end
end
