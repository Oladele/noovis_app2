class NetworkGraphResource < JSONAPI::Resource
  attributes :nodes, :edges
  has_one :sheet

  filter :sheet

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      NetworkGraph.includes(:company).where(companies: {id: current_user.company_id}).references(:company)
    else
      super
    end
  end

  def nodes
    cached_nodes_and_edges[:nodes]
  end

  def edges
    cached_nodes_and_edges[:edges]
  end

  private
    def cached_nodes_and_edges
      @nodes_and_edges ||= self.model.nodes_and_edges
      @nodes_and_edges
    end
end
