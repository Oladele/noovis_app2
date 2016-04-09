class GlobalResource < JSONAPI::Resource
  attributes :node_counts

  def self.find_by_key(_key, options={})
    context = options[:context]
    model = Global.new
    new(model, context)
  end

  def self.verify_key(key, _context = nil)
    key && String(key)
  end

  def node_counts
    network_graphs = NetworkGraph.all_for Company.all
    building_count = Company.all.map { |company| company.buildings.count }.
      reduce(:+)
    site_count = NetworkSite.all.map { |site| site.buildings.count }.
      reduce(:+)

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

    node_counts.unshift({node_type: "buildings", count: building_count, node_type_pretty: "Buildings"})
    node_counts.unshift({node_type: "network-sites", count: site_count, node_type_pretty: "Sites"})
  end
end
