class NetworkSiteResource < JSONAPI::Resource
  attributes :name, :lat, :lng
  has_one :company
  
  filter :company
end
