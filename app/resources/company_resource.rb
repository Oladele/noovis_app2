class CompanyResource < JSONAPI::Resource
  attributes :name, :node_counts
  has_many :network_sites, :buildings, :users

  def node_counts
  	network_graphs = NetworkGraph.all_for @model

		if not network_graphs.empty?
	  	nodes = Node.all_for network_graphs
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
			node_counts = stats.node_counts node_types
		else
			node_counts = []
		end

    node_counts.unshift({node_type: "buildings", count: buildings.count, node_type_pretty: "Buildings"})
    node_counts.unshift({node_type: "network-sites", count: network_sites.count, node_type_pretty: "Sites"})
  end
end
