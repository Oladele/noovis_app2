# == Schema Information
#
# Table name: network_sites
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address    :string
#  company_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lat        :decimal(10, 6)
#  lng        :decimal(10, 6)
#

class NetworkSite < ActiveRecord::Base
  belongs_to :company
  has_many :buildings, dependent: :destroy
  has_many :workbooks, dependent: :destroy

  validates :name, presence: true
  validates :company_id, presence: true
  validates :name, uniqueness: { scope: [:company_id] }

  def chart_distribution_ports_buildings
  	aggregrate_buildings(:distribution_ports, "Active Distribution Ports", "Spare Distribution Ports")
  end

  def chart_distribution_ports_site
  	data = self.chart_distribution_ports_buildings
    aggregrate_site(data, "Active Distribution Ports", "Spare Distribution Ports")
  end

  def chart_feeder_capacity_buildings
  	aggregrate_buildings(:feeder_capacity, "Active PON Ports", "Spare Feeder Fibers")
  end

  def chart_feeder_capacity_site
  	data = self.chart_feeder_capacity_buildings
    aggregrate_site(data, "Active PON Ports", "Spare Feeder Fibers")
  end

  def chart_pon_usage_buildings
  	aggregrate_buildings(:pon_usage, "Active Channels", "Standby Channels")
  end

  def chart_pon_usage_site
  	data = self.chart_pon_usage_buildings
    aggregrate_site(data, "Active Channels", "Standby Channels")
  end

  def network_element_counts
    distribution_ports = self.chart_distribution_ports_site
    feeder_capacity = self.chart_feeder_capacity_site
    pon_usage = self.chart_pon_usage_site

    node_counts = node_counts_for_all_buildings

    counts = [
      {
        "BLDG" => self.name,
        "Bldgs" => self.buildings.count,
        "OLTs" => node_counts["olt_chassis"] || 0,
        "PON Cards" => node_counts["pon_card"] || 0,
        "FDHs" => node_counts["fdh"] || 0,
        "Splitters" => node_counts["splitter"] || 0,
        "RDTs" => node_counts["rdt"] || 0,
        "ONTs" => node_counts["ont_sn"] || 0,
        "WAPs" => node_counts["TODO"] || 0,
        "Rooms" => node_counts["room"] || 0,
        "Active Channels" => pon_usage["Active Channels"],
        "Standby Channels" => pon_usage["Standby Channels"],
        "Active PON Ports" => feeder_capacity["Active PON Ports"],
        "Spare Feeder Fibers" => feeder_capacity["Spare Feeder Fibers"],
        "Active Distribution Ports" => distribution_ports["Active Distribution Ports"],
        "Spare Distribution Ports" => distribution_ports["Spare Distribution Ports"],
        "Actual RDT Count" => node_counts["rdt"] || 0
      }
    ]

    network_graphs = NetworkGraph.all_for(self)
    network_graphs.each do |network_graph|
      node_counts = network_graph.node_count_values

      pon_usage = data_for_network_graph(:pon_usage, network_graph, node_counts, "Active Channels", "Standby Channels")
      feeder_capacity = data_for_network_graph(:feeder_capacity, network_graph, node_counts, "Active PON Ports", "Spare Feeder Fibers")
      distribution_ports = data_for_network_graph(:distribution_ports, network_graph, node_counts, "Active Distribution Ports", "Spare Distribution Ports")

      counts << {
        "BLDG" => network_graph.sheet.building.name,
        "Bldgs" => 1,
        "OLTs" => node_counts["olt_chassis"] || 0,
        "PON Cards" => node_counts["pon_card"] || 0,
        "FDHs" => node_counts["fdh"] || 0,
        "Splitters" => node_counts["splitter"] || 0,
        "RDTs" => node_counts["rdt"] || 0,
        "ONTs" => node_counts["ont_sn"] || 0,
        "WAPs" => node_counts["TODO"] || 0,
        "Rooms" => node_counts["room"] || 0,
        "Active Channels" => pon_usage.first[:value],
        "Standby Channels" => pon_usage.last[:value],
        "Active PON Ports" => feeder_capacity.first[:value],
        "Spare Feeder Fibers" => feeder_capacity.last[:value],
        "Active Distribution Ports" => distribution_ports.first[:value],
        "Spare Distribution Ports" => distribution_ports.last[:value],
        "Actual RDT Count" => node_counts["rdt"] || 0
      }
    end

    counts
  end

  private
    def aggregrate_buildings(type, active_key, passive_key)
      network_graphs = NetworkGraph.all_for(self)

      network_graphs.each_with_object([]) do |network_graph, array|
        node_counts = network_graph.node_count_values
        data = data_for_network_graph(type, network_graph, node_counts, active_key, passive_key)
        data.each { |hash| array << hash }
      end
    end

    def data_for_network_graph(type, network_graph, node_counts, active_key, passive_key)
        group = network_graph.sheet.building.name
        values = values_for_type(type, node_counts)

        [{ label: active_key, group: group, value: values[:actives] },
        { label: passive_key, group: group, value: values[:passives] }]
    end

    def values_for_type(type, node_counts)
      case type
      when :distribution_ports
        actives = node_counts["ont_sn"] || 0
        rdt_count = node_counts["rdt"] || 0

        spares = (rdt_count * 12) - actives

        { actives: actives, passives: spares }
      when :feeder_capacity
        actives = node_counts["splitter"] || 0
        spares = 12 - actives

        { actives: actives, passives: spares }
      when :pon_usage
        actives = node_counts["ont_sn"] || 0
        splitters = node_counts["splitter"] || 0
        standbys = (splitters * 32) - actives

        { actives: actives, passives: standbys }
      end
    end

    def aggregrate_site(data, active_key, passive_key)
      data.each_with_object({ active_key => 0, passive_key => 0 }) do |hash, result|
        key = hash[:label] == active_key ? active_key : passive_key
        result[key] += hash[:value]
      end
    end

    def node_counts_for_all_buildings
      # TODO: If we stored the node_counts this would be faster
      network_graphs = NetworkGraph.all_for(self)
      network_graphs_counts = network_graphs.inject { |a, b| a.node_count_values.merge(b.node_count_values) { |k, val1, val2| val1 + val2 } }
    end
end
