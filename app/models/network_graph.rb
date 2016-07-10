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

  validates :sheet_id, :graph, :nodes, :edges, :node_counts, presence: true

  attr_reader :nodes_in_memory

  def NetworkGraph.latest_for(building)
  	sheets_with_graphs = building.sheets.which_have_graphs
  	return nil if sheets_with_graphs.empty?

  	latest_sheet = sheets_with_graphs.last
  	latest_graph = latest_sheet.network_graphs.last

    latest_graph.graph.present? && latest_graph.nodes.present? && latest_graph.edges.present? && latest_graph.node_counts.present? ? latest_graph : nil
  end

  def NetworkGraph.destroy_all_for(building)
    building.sheets.which_have_graphs.each { |sheet| sheet.network_graphs.destroy_all }
  end

  def self.create_from_graph(sheet, graph)
    nodes_and_edges = NetworkGraph.nodes_and_edges(graph)
    node_counts = NetworkGraph.collect_node_counts(nodes_and_edges[:nodes])

    NetworkGraph.create!(sheet: sheet, graph: graph, nodes: nodes_and_edges[:nodes], edges: nodes_and_edges[:edges], node_counts: node_counts)
  end

  def self.nodes_and_edges(graph)
    iteration_helper = IterationHelper.new(1)

    return {} if graph.nil?

    graph[:sites].each do |site|
      collection = site[site.keys.last]

      generate_for_collection(iteration_helper, collection, site.keys.last.to_s.singularize, 1, nil, 1)
    end

    { nodes: iteration_helper.nodes, edges: iteration_helper.edges }
  end

  def self.node_counts_for_graphs(network_graphs)
    unless network_graphs.blank?
      if network_graphs.count > 1
        counts = network_graphs.inject do |a, b|
          value = a.is_a?(Hash) ? a : a.node_counts
          value.merge(b.node_counts) { |k, val1, val2| val1 + val2 }
        end

        self.adjust_for_unique_nodes(network_graphs, counts)
      else
        network_graphs.first.node_counts
      end
    else
      nil
    end
  end

  def self.pretty_node_counts_for_graphs(network_graphs)
    node_counts = NetworkGraph.node_counts_for_graphs(network_graphs)
    NetworkGraph.node_counts_pretty(node_counts)
  end

  def self.node_counts_pretty(node_counts)
    return [] if node_counts.blank?

    waps_count = 0

    counts = node_counts.each_with_object([]) do |(node_type, count), array|
      if %w(ont_ge_1_mac ont_ge_2_mac ont_ge_3_mac ont_ge_4_mac).include?(node_type)
        waps_count += count
      else
        array << { node_type: node_type, count: count, node_type_pretty: NetworkGraph.label_for_node_type(node_type) }
      end
    end

    counts << { node_type: 'wap', count: waps_count, node_type_pretty: NetworkGraph.label_for_node_type('wap') }
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

          generate_for_collection(iteration_helper, nested_collection,  object.keys.last.to_s.singularize, next_node_level, previous_parent_id, row_id)
        end

        row_id += 1
      end
    end

    def self.collect_node_counts(nodes)
      return {} if nodes.nil?

      nodes.each_with_object({}) do |node, hash|
        node_type = node[:node_type]

        if node_type.present?
          node_value = node[:node_value]
          increment_value = node_value.present? && value_isnt_blank?(node_value) ? 1 : 0
          if hash.has_key?(node_type)
            hash[node_type] += increment_value
          else
            hash[node_type] = increment_value
          end
        end
      end
    end

    def self.label_for_node_type(node_type)
      case node_type
      when "olt_chassis"
        "OLT Chassis"
      when "olt"
        "OLTs"
      when "pon_card"
        "PON Cards"
      when "pon_port"
        "PON Ports"
      when "building"
        "Buildings"
      when "fdh"
        "FDHs"
      when "splitter"
        "Splitters"
      when "rdt"
        "RDTs"
      when "room"
        "Rooms"
      when "ont_sn"
        "ONTs"
      when "wap"
        "WAPs"
      else
        raise "NetworkGraph.label_for_node_type: unknown node_type"
      end
    end

    def self.adjust_for_unique_nodes(network_graphs, node_counts)
      data = {}
      olt_count = 0
      card_count = 0
      port_count = 0

      # TODO: We're checking in two places for a N/A value, that should be done when we build the graph the first
      network_graphs.each do |network_graph|
        next if network_graph.graph.try(:[], "sites").blank?

        network_graph.graph["sites"].each do |site|
          next if site.try(:[], "olt_chassis").blank?

          site["olt_chassis"].each do |olt_chassis|
            next unless self.value_isnt_blank?(olt_chassis["value"])

            unless data.has_key?(olt_chassis["value"]).present?
              data[olt_chassis["value"]] = {}
              olt_count += 1
            end

            chassis_hash = data[olt_chassis["value"]]

            olt_chassis["pon_cards"].each do |pon_card|
              unless chassis_hash.has_key?(pon_card["value"]).present?
                chassis_hash[pon_card["value"]] = {}
                card_count += 1
              end

              card_hash = chassis_hash[pon_card["value"]]

              pon_card["pon_ports"].each do |pon_port|
                unless card_hash.has_key?(pon_port["value"]).present?
                  card_hash[pon_port["value"]] = {}
                  port_count += 1
                end
              end
            end
          end
        end
      end

      node_counts["olt_chassis"] = olt_count
      node_counts["pon_card"] = card_count
      node_counts["pon_port"] = port_count

      node_counts
    end

    def self.value_isnt_blank?(value)
      ["n/a", "na", "blank"].exclude?(value.strip.downcase)
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

