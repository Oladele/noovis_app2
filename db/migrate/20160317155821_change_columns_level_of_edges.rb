class ChangeColumnsLevelOfEdges < ActiveRecord::Migration
  
  def change
	  change_table :edges do |t|
	  	t.rename :to_node, :to_node_id
	  	t.rename :from_node, :from_node_id
	  	t.rename :level, :edge_level
	  end
  end

end
