class BuildingResource < JSONAPI::Resource
  attributes :name, :lat, :lng, :description, :node_counts, :import_job_status
  has_one :network_site
  has_many :sheets

  filter :network_site

  def node_counts
    network_graph = NetworkGraph.latest_for @model
    if network_graph.present?
      NetworkGraph.pretty_node_counts_for_graphs([network_graph])
    else
      []
    end
  end

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      Building.includes(:company).where(companies: {id: current_user.company_id}).references(:company)
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
