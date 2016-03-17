# == Schema Information
#
# Table name: edges
#
#  id               :integer          not null, primary key
#  network_graph_id :integer
#  to_node_id       :integer
#  from_node_id     :integer
#  edge_level       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Edge < ActiveRecord::Base
  belongs_to :network_graph
end
