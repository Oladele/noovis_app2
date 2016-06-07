class AddGraphToNetworkGraphs < ActiveRecord::Migration
  def change
    add_column :network_graphs, :graph, :json
  end
end
