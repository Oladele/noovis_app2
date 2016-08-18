class CompanyResource < JSONAPI::Resource
  caching
  attributes :name, :node_counts
  has_many :network_sites, :buildings, :users

  def node_counts
    network_graphs = @model.network_graphs
    node_counts = NetworkGraph.pretty_node_counts_for_graphs(network_graphs)

    node_counts.unshift({
      node_type: "buildings",
      count: @model.buildings.count,
      node_type_pretty: "Buildings"
    })

    node_counts.unshift({
      node_type: "network-sites",
      count: @model.network_sites.count,
      node_type_pretty: "Sites"
    })

    node_counts
  end

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      Company.where(id: current_user.company_id)
    else
      super
    end
  end
end
