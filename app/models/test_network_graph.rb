# An integer is passed by value, so when looping we need to retrieve and increment the same value,
# not a copy of the value. Wrapping this in an object gives us the same pass by reference-ness of objects.
class IterationHelper
  attr_accessor :index, :nodes, :edges

  def initialize(index)
    self.index = index
    self.nodes = []
    self.edges = []
  end

  def increment
    self.index += 1
  end
end

class TestNetworkGraph < ActiveRecord::Base
  belongs_to :building

  validates :graph, presence: true

  def nodes_and_edges
    iteration_helper = IterationHelper.new(1)

    graph["sites"].each do |site|
      collection = site[site.keys.last]

      generate_for_collection(iteration_helper, collection, singular_node_type(site.keys.last), 1, nil, 1)
    end

    { nodes: iteration_helper.nodes, edges: iteration_helper.edges }
  end

  def node_counts
    nodes = self.nodes_and_edges[:nodes]

    nodes.each_with_object([]) do |node, array|
      node_type = node[:node_type]

      counter = array.select { |object| object[:node_type] == node_type }.first

      if counter.nil?
        array << { node_type: node_type, count: 1, node_type_pretty: node_type.pluralize.titleize }
      else
        counter[:count] += 1
      end
    end
  end

  private
    def generate_for_collection(iteration_helper, collection, node_type, node_level, parent_id, row_id)
      collection.each do |object|
        node = {
          id: iteration_helper.index,
          label: "#{node_type.upcase}: #{object["value"]}",
          cable_run_id: row_id,
          level: node_level.to_s,
          node_type: node_type,
          node_value: object["value"],
          parent_id: parent_id
        }
        iteration_helper.nodes << node

        # If there is a parent, then we need to make an edge.
        if parent_id.present?
          edge = {
            id: iteration_helper.index - 1,   # Offset so it starts on index 1, since it passes the first loop.
            to: node[:id],
            from: parent_id
          }
          iteration_helper.edges << edge
        end

        iteration_helper.increment

        nested_collection = object[object.keys.last]

        if nested_collection.present? && nested_collection.is_a?(Array)
          # Ports have the same node level and parent_id
          is_port_node = ["ont_ge_2_macs", "ont_ge_3_macs", "ont_ge_4_macs"].include?(object.keys.last)
          next_node_level = is_port_node ? node_level : node_level + 1
          previous_parent_id = is_port_node ? parent_id : node[:id]

          generate_for_collection(iteration_helper, nested_collection, singular_node_type(object.keys.last), next_node_level, previous_parent_id, row_id)
        end

        row_id += 1
      end
    end

    def singular_node_type(node_type)
      node_type == "olt_chasses" ? "olt_chassis" : node_type.to_s.singularize
    end
end
