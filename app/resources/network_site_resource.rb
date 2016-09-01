class NetworkSiteResource < JSONAPI::Resource
  attributes :name, :lat, :lng, :address, :node_counts
  has_one :company
  has_many :buildings
  has_many :workbooks

  filter :company

  def node_counts
    network_graphs = @model.network_graphs
    node_counts = NetworkGraph.pretty_node_counts_for_graphs(network_graphs)

    node_counts.unshift({
      node_type: "buildings",
      count: @model.buildings.count,
      node_type_pretty: "Buildings"
    })

    node_counts
  end

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      NetworkSite.where(company_id: current_user.company_id)
    else
      super
    end
  end

  def self.updatable_fields(context)
    super - [:node_counts]
  end

  def self.creatable_fields(context)
    super - [:node_counts]
  end
end
