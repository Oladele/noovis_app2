class CompanyResource < JSONAPI::Resource
  attributes :name
  has_many :network_sites
end