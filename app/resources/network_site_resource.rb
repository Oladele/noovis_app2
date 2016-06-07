class NetworkSiteResource < JSONAPI::Resource
  attributes :name, :lat, :lng, :address, :node_counts
  has_one :company
  has_many :buildings
  has_many :workbooks

  filter :company


  def node_counts
  	network_graphs = NetworkGraph.all_for @model

		node_counts =
      if network_graphs.present?
        nodes = Node.all_for(network_graphs)

        if nodes.present?
          node_types = [
            "olt_chassis",
            "pon_card",
            "fdh",
            "splitter",
            "rdt",
            "ont_sn",
            "room"
          ]

          stats = NodeStats.new nodes
          stats.node_counts node_types
        else
          []
        end
      else
        []
      end

    node_counts.unshift({node_type: "buildings", count: buildings.count, node_type_pretty: "Buildings"})
  end

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      NetworkSite.where(company_id: current_user.company_id)
    else
      super
    end
  end
end
