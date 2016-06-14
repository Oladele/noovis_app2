# == Schema Information
#
# Table name: network_graphs
#
#  id                  :integer          not null, primary key
#  sheet_id            :integer
#  network_template_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class NetworkGraph < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :network_template
  has_one :company, through: :sheet

  validates :sheet_id, :graph, :nodes, :edges, presence: true

  attr_reader :nodes_in_memory

  def NetworkGraph.all_for model_or_models
    network_graphs = []

    if model_or_models.respond_to?(:to_ary)
      network_graphs = NetworkGraph.all_for_array model_or_models
    else
      network_graphs = NetworkGraph.all_for_single model_or_models
    end

  end

  def NetworkGraph.all_for_array(models)
    network_graphs = []
    models.each do |model|
      network_graphs << NetworkGraph.all_for_single(model)
    end
    network_graphs.flatten
  end

  def NetworkGraph.all_for_single(model)
    network_graphs = []
    buildings = model.buildings
    network_graphs = buildings.map do |building|
      NetworkGraph.latest_for building
    end
    network_graphs.compact
  end

  def NetworkGraph.latest_for(building)

  	sheets_with_graphs = building.sheets.which_have_graphs
  	return nil if sheets_with_graphs.empty?

  	latest_sheet = sheets_with_graphs.last
  	latest_graph = latest_sheet.network_graphs.last

    latest_graph.graph.present? && latest_graph.nodes.present? && latest_graph.edges.present? ? latest_graph : nil
  end

  def NetworkGraph.destroy_all_for(building)
    building.sheets.which_have_graphs.each { |sheet| sheet.network_graphs.destroy_all }
  end

  def self.create_from_graph(sheet, graph)
    nodes_and_edges = NetworkGraph.nodes_and_edges(graph)

    NetworkGraph.create!(sheet: sheet, graph: graph, nodes: nodes_and_edges[:nodes], edges: nodes_and_edges[:edges])
  end

  def self.nodes_and_edges(graph)
    iteration_helper = IterationHelper.new(1)

    return {} if graph.nil?

    graph[:sites].each do |site|
      collection = site[site.keys.last]

      generate_for_collection(iteration_helper, collection, singular_node_type(site.keys.last), 1, nil, 1)
    end

    { nodes: iteration_helper.nodes, edges: iteration_helper.edges }
  end

  def node_counts
    nodes = self.nodes

    return [] if nodes.nil?

    nodes.each_with_object([]) do |node, array|
      node_type = node["node_type"]

      counter = array.select { |object| object[:node_type] == node_type }.first

      if counter.nil?
        array << { node_type: node_type, count: 1, node_type_pretty: node_type.pluralize.titleize }
      else
        counter[:count] += 1
      end
    end
  end

  def node_count_for_type(node_type)
    self.nodes.select { |node| node["node_type"] == node_type }.count
  end

  private
    def self.generate_for_collection(iteration_helper, collection, node_type, node_level, parent_id, row_id)
      collection.each do |object|
        node = {
          id: iteration_helper.index,
          label: "#{node_type.upcase}: #{object[:value]}",
          cable_run_id: object[:cable_run_id],
          level: node_level.to_s,
          node_type: node_type,
          node_value: object[:value],
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
          is_port_node = [:ont_ge_2_macs, :ont_ge_3_macs, :ont_ge_4_macs].include?(object.keys.last)
          next_node_level = is_port_node ? node_level : node_level + 1
          previous_parent_id = is_port_node ? parent_id : node[:id]

          generate_for_collection(iteration_helper, nested_collection, singular_node_type(object.keys.last), next_node_level, previous_parent_id, row_id)
        end

        row_id += 1
      end
    end

    def self.singular_node_type(node_type)
      node_type == :olt_chasses ? "olt_chassis" : node_type.to_s.singularize
    end
end

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

