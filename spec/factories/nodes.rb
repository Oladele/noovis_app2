# == Schema Information
#
# Table name: nodes
#
#  id               :integer          not null, primary key
#  network_graph_id :integer
#  node_type_id     :integer
#  node_value       :string
#  x_pos            :decimal(8, 2)
#  y_pos            :decimal(8, 2)
#  node_level       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :node do
    network_graph
    node_type
    node_value "MyString"
    x_pos {9.99}
    y_pos {9.99}
    node_level 1
  end

end
