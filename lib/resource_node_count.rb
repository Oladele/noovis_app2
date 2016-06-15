module ResourceNodeCount
  def node_counts
    if is_global?
      network_graphs = NetworkGraph.all_for Company.all
      building_count = Building.count
      site_count = NetworkSite.count
    else
      network_graphs = is_building? ?  NetworkGraph.latest_for(@model) : NetworkGraph.all_for(@model)
      building_count = @model.buildings.count unless is_building?
      site_count = @model.network_sites.count unless is_building? || is_site?
    end

    node_counts = node_counts_from_graphs(network_graphs)

    node_counts.unshift({
      node_type: "buildings",
      count: building_count,
      node_type_pretty: "Buildings"
    }) unless is_building?

    node_counts.unshift({
      node_type: "network-sites",
      count: site_count,
      node_type_pretty: "Sites"
    }) unless is_building? || is_site?

    node_counts
  end

  private

  def node_counts_from_graphs(network_graphs)
		if network_graphs
      nodes = network_graphs.is_a?(Array) ? network_graphs.collect { |network_graph| network_graph.nodes }.flatten : network_graphs.nodes
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
  end

  def is_building?
    @model.is_a? Building
  end

  def is_site?
    @model.is_a? NetworkSite
  end

  def is_global?
    @model.is_a? Global
  end
end
