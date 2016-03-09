class WorkbookResource < JSONAPI::Resource
  attributes :name
  has_one :network_site
  has_many :sheets

  filter :network_site
end
