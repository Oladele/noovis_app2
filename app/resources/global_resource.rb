class GlobalResource < JSONAPI::Resource
  attributes :node_counts

  def node_counts
    network_graphs = Global.network_graphs
    node_counts = NetworkGraph.pretty_node_counts_for_graphs(network_graphs)

    node_counts.unshift({ node_type: "buildings", count: Building.count, node_type_pretty: "Buildings" })
    node_counts.unshift({ node_type: "network-sites", count: NetworkSite.count, node_type_pretty: "Sites" })

    node_counts
  end

  def self.find_by_key(_key, options={})
    context = options[:context]
    model = Global.new
    new(model, context)
  end

  def self.verify_key(key, _context = nil)
    key && String(key)
  end
end
