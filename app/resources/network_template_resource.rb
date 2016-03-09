class NetworkTemplateResource < JSONAPI::Resource
  has_many :network_graphs

  attributes :name, :description, :hierarchy
end
