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

  def network_graphs
    self.buildings.collect { |building| NetworkGraph.latest_for(building) }.compact
  end

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

  def chart_distribution_spares_buildings
    self.buildings.collect do |building|
      NetworkSite.spares_from_cable_runs(building.name, building.latest_sheet.cable_runs)
    end.flatten
  end

  def network_element_counts
    distribution_ports = self.chart_distribution_ports_site
    feeder_capacity = self.chart_feeder_capacity_site
    pon_usage = self.chart_pon_usage_site

    network_graphs = self.network_graphs
    node_counts = NetworkGraph.node_counts_for_graphs(network_graphs)

    waps = (node_counts["ont_ge_1_mac"] || 0) +
      (node_counts["ont_ge_2_mac"] || 0) +
      (node_counts["ont_ge_3_mac"] || 0) +
      (node_counts["ont_ge_4_mac"] || 0)

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
        "WAPs" => waps,
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

    network_graphs.each do |network_graph|
      pon_usage = data_for_network_graph(:pon_usage, network_graph, "Active Channels", "Standby Channels")
      feeder_capacity = data_for_network_graph(:feeder_capacity, network_graph, "Active PON Ports", "Spare Feeder Fibers")
      distribution_ports = data_for_network_graph(:distribution_ports, network_graph, "Active Distribution Ports", "Spare Distribution Ports")

      node_counts = network_graph.node_counts

      waps = (node_counts["ont_ge_1_mac"] || 0) +
        (node_counts["ont_ge_2_mac"] || 0) +
        (node_counts["ont_ge_3_mac"] || 0) +
        (node_counts["ont_ge_4_mac"] || 0)

      counts << {
        "BLDG" => network_graph.sheet.building.name,
        "Bldgs" => 1,
        "OLTs" => node_counts["olt_chassis"] || 0,
        "PON Cards" => node_counts["pon_card"] || 0,
        "FDHs" => node_counts["fdh"] || 0,
        "Splitters" => node_counts["splitter"] || 0,
        "RDTs" => node_counts["rdt"] || 0,
        "ONTs" => node_counts["ont_sn"] || 0,
        "WAPs" => waps,
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
      network_graphs = self.network_graphs
      network_graphs.each_with_object([]) do |network_graph, array|
        data = data_for_network_graph(type, network_graph, active_key, passive_key)
        data.each { |hash| array << hash }
      end
    end

    def data_for_network_graph(type, network_graph, active_key, passive_key)
        group = network_graph.sheet.building.name
        values = values_for_type(type, network_graph.node_counts)

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

    def self.spares_from_cable_runs(building_name, cable_runs)
      cable_runs.each_with_object([]) do |cable_run, array|
        room =
          if cable_run.room =~ /\A\d+\z/  # room is an integer?
            cable_run.room.to_i < 100 ? "Ground Floor" : "Floor #{cable_run.room[0]}"
          else
            "#{cable_run.room.capitalize} Floor"  # non-numeric values, ex: "Lobby"
          end

        exists = array.select { |x| x[:label] == room }.first
        value = NetworkGraph.value_isnt_blank?(cable_run.rdt) && cable_run.drop.downcase.strip == "spare" ? 1 : 0

        if exists.blank?
          array << { label: room, group: building_name, value: value }
        else
          exists[:value] += value
        end
      end
    end
end
