class AddNodesEdgesToNetworkGraphs < ActiveRecord::Migration
  def change
    add_column :network_graphs, :nodes, :json
    add_column :network_graphs, :edges, :json
  end
end
