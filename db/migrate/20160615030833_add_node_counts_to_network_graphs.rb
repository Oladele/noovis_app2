class AddNodeCountsToNetworkGraphs < ActiveRecord::Migration
  def change
    add_column :network_graphs, :node_counts, :json
  end
end
