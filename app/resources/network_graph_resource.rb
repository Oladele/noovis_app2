class NetworkGraphResource < JSONAPI::Resource
  attributes :nodes, :edges
  has_one :sheet
  has_one :network_template
  has_many :nodes

  filter :sheet
end
