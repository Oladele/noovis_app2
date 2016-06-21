module ResourceNodeCount
  def node_counts
    is_building = @model.is_a?(Building)
    is_site = @model.is_a?(NetworkSite)

    if @model.is_a?(Global)
      network_graphs = NetworkGraph.all_for Company.all
      building_count = Building.count
      site_count = NetworkSite.count
    else
      network_graphs = is_building ?  NetworkGraph.latest_for(@model) : NetworkGraph.all_for(@model)
      building_count = @model.buildings.count unless is_building
      site_count = @model.network_sites.count unless is_building || is_site
    end

    node_counts = node_counts_from_graphs(network_graphs)

    node_counts.unshift({
      node_type: "buildings",
      count: building_count,
      node_type_pretty: "Buildings"
    }) unless is_building

    node_counts.unshift({
      node_type: "network-sites",
      count: site_count,
      node_type_pretty: "Sites"
    }) unless is_building || is_site

    node_counts
  end

  private
    def node_counts_from_graphs(network_graphs)
      network_graphs ? NetworkGraph.pretty_node_counts_for_graphs(network_graphs) : []
    end
end
