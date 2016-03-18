# == Schema Information
#
# Table name: nodes
#
#  id               :integer          not null, primary key
#  network_graph_id :integer
#  node_value       :string
#  node_level       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_id        :integer
#  cable_run_id     :integer
#  node_type        :string
#  label            :string
#  level            :string
#

FactoryGirl.define do
  factory :node do
    network_graph
    node_type "MyString"
    node_value "MyString"
    node_level 1
  end

end
