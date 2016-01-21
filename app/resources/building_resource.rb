class BuildingResource < JSONAPI::Resource
  attributes :name, :lat, :lng, :description
  has_one :network_site
  
  filter :network_site
end
