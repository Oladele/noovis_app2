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

FactoryGirl.define do
  factory :edge do
    network_graph nil
to_node 1
from_node 1
level 1
  end

end
