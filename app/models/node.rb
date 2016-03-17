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
#

class Node < ActiveRecord::Base
  belongs_to :network_graph
  belongs_to :parent, class_name: "Node"
  has_many :children, class_name: "Node", foreign_key: "parent_id"
  belongs_to :cable_run

  validates :network_graph_id, presence: true

  def is_blank
    @node_value == "" or node_value == nil or (/blank/ =~ node_value) == 0
  end

  def is_na
    (/N\/A/ =~ node_value) == 0
  end
end
