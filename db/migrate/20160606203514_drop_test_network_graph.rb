class DropTestNetworkGraph < ActiveRecord::Migration
  def change
    drop_table :test_network_graphs
  end
end
