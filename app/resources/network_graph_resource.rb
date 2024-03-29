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
end
