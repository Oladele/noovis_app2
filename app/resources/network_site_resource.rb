class NetworkSiteResource < JSONAPI::Resource
  attributes :name
  has_one :company
  
  filter :company
end