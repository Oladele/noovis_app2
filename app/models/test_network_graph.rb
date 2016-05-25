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

      generate_for_collection(iteration_helper, collection, site.keys.last.to_s.singularize, 1, nil)
    end

    { nodes: iteration_helper.nodes, edges: iteration_helper.edges }
  end

  private
    def generate_for_collection(iteration_helper, collection, node_type, node_level, parent_id)
      collection.each do |object|
        node = {
          id: iteration_helper.index,
          label: "#{node_type.upcase}: #{object["value"]}",
          cable_run_id: 22,       # TODO: do we need this?
          network_graph_id: 55,   # TODO: do we need this?
          node_level: node_level,
          node_type: node_type,
          node_value: object["value"],
          parent_id: parent_id,
          created_at: self.created_at,
          updated_at: self.updated_at
        }
        iteration_helper.nodes << node

        # If there is a parent, then we need to make an edge.
        if parent_id.present?
          edge = {
            id: iteration_helper.index - 1,   # Offset so it starts on index 1, since it passes the first loop.
            network_graph_id: 55, # TODO: do we need this?
            to_node_id: node[:id],
            from_node_id: parent_id,
            edge_level: node_level - 1,       # Offset so it starts on index 1, since it passes the first loop.
            created_at: self.created_at,
            updated_at: self.updated_at
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

          generate_for_collection(iteration_helper, nested_collection, object.keys.last.to_s.singularize, next_node_level, previous_parent_id)
        end
      end
    end
end
