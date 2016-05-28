class CompanyResource < JSONAPI::Resource
  include ResourceNodeCount

  attributes :name, :node_counts
  has_many :network_sites, :buildings, :users

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      Company.where(id: current_user.company_id)
    else
      super
    end
  end
end
