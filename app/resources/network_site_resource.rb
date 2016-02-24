class NetworkSiteResource < JSONAPI::Resource
  attributes :name, :lat, :lng
  has_one :company
  has_many :buildings
  
  filter :company
end
