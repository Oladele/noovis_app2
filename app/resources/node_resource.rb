class NodeResource < JSONAPI::Resource
  attributes :node_value, :node_level, :node_type
  has_one :network_graph

  filter :network_graph

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      Node.includes(:company).where(companies: {id: current_user.company_id}).references(:company)
    else
      super
    end
  end
end
