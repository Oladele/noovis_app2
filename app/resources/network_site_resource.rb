class NetworkSiteResource < JSONAPI::Resource
  include ResourceNodeCount

  attributes :name, :lat, :lng, :address, :node_counts
  has_one :company
  has_many :buildings
  has_many :workbooks

  filter :company

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      NetworkSite.where(company_id: current_user.company_id)
    else
      super
    end
  end
end
