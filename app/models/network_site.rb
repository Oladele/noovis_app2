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
  	network_graphs = NetworkGraph.all_for(self)

    network_graphs.each_with_object([]) do |network_graph, array|
      group = network_graph.sheet.building.name

      actives = network_graph.node_count_for_type("ont_sn")
      rdt_count = network_graph.node_count_for_type("rdt")

      spares = (rdt_count * 12) - actives

      array << { label: "Active Distribution Ports", group: group, value: actives }
      array << { label: "Spare Distribution Ports", group: group, value: spares }
    end
  end

  def chart_distribution_ports_sites
  	data = self.chart_distribution_ports_buildings

    result = { "Active Distribution Ports" => 0, "Spare Distribution Ports" => 0 }

    data.each do |hash|
      if hash[:label] == "Active Distribution Ports"
        result["Active Distribution Ports"] += hash[:value]
      else
        result["Spare Distribution Ports"] += hash[:value]
      end
    end

    result
  end
end
