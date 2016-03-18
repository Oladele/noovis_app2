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

require 'rails_helper'

RSpec.describe Edge, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
