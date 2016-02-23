class WorkbookResource < JSONAPI::Resource
  attributes :name
  has_one :network_site

  filter :network_site
end
