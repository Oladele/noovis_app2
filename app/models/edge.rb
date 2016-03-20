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
#  level            :integer
#  to               :integer
#  from             :integer
#


# TODO: Below fields should be presentation concern
# Think fix should involve moving nodes to association of json_api resource
# rather than attribute. Then presentation concern can be addresses in resource
#  level            :integer
#  to               :integer
#  from             :integer

class Edge < ActiveRecord::Base
  belongs_to :network_graph
end
