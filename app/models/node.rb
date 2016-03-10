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

class Node < ActiveRecord::Base
  belongs_to :network_graph
  belongs_to :node_type

  validates :network_graph_id, presence: true
  validates :node_type_id, presence: true
end
