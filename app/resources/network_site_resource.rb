class NetworkSiteResource < JSONAPI::Resource
  attributes :name, :lat, :lng, :address
  has_one :company
  has_many :buildings
  has_many :workbooks
  
  filter :company
end
