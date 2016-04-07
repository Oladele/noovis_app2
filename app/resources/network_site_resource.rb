class NetworkSiteResource < JSONAPI::Resource
  attributes :name, :lat, :lng, :address, :node_counts
  has_one :company
  has_many :buildings
  has_many :workbooks
  
  filter :company


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
  end
end
