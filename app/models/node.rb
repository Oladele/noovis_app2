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

# TODO: Below fields should be presentation concern
# Think fix should involve moving nodes to association of json_api resource
# rather than attribute. Then presentation concern can be addresses in resource
#  label            :string
#  level            :string


class Node < ActiveRecord::Base
  belongs_to :network_graph
  belongs_to :parent, class_name: "Node"
  has_one :company, through: :network_graph
  has_many :children, class_name: "Node", foreign_key: "parent_id"
  belongs_to :cable_run

  validates :network_graph_id, presence: true
  validates :node_type, presence: true

  def is_blank
    @node_value == "" or node_value == nil or (/blank/ =~ node_value) == 0
  end

  def is_na
    (/N\/A/ =~ node_value) == 0
  end

  def label
    if is_blank
      label = "\n#{node_type.upcase}:\n blank"
    elsif is_na
      label = "\n#{node_type.upcase}:\n N/A"
    else
      label = "\n#{node_type.upcase}:\n #{node_value}"
    end
    label
  end


  def Node.all_for model_or_models
    nodes = []

    if model_or_models.respond_to?(:to_ary)
      nodes = Node.all_for_array model_or_models
    else
      nodes = Node.all_for_single model_or_models
    end

  end


  def Node.all_for_array(network_graphs)
    nodes = []
    network_graphs.each do |network_graph|
      nodes << Node.all_for_single(network_graph)
    end
    nodes.flatten
  end

  def Node.all_for_single(network_graph)
    nodes = network_graph.nodes
  end


end
