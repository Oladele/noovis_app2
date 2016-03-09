class BuildingResource < JSONAPI::Resource
  attributes :name, :lat, :lng, :description
  has_one :network_site
  has_many :sheets
  
  filter :network_site
end
