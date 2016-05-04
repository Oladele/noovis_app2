class BuildingResource < JSONAPI::Resource
  attributes :name, :lat, :lng, :description, :node_counts, :import_job_status
  has_one :network_site
  has_many :sheets

  filter :network_site

  def node_counts
  	network_graph = NetworkGraph.latest_for @model

		if network_graph
	  	nodes = network_graph.nodes
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
