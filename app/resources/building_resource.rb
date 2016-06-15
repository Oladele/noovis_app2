class BuildingResource < JSONAPI::Resource
  attributes :name, :lat, :lng, :description, :node_counts, :import_job_status
  has_one :network_site
  has_many :sheets

  filter :network_site

  def node_counts
    network_graph = NetworkGraph.latest_for @model
    network_graph.present? ? network_graph.node_counts_pretty : []
  end

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      Building.includes(:company).where(companies: {id: current_user.company_id}).references(:company)
    else
      super
    end
  end
end
