class NetworkGraphResource < JSONAPI::Resource
  has_one :sheet
  has_one :network_template
  has_many :nodes

  filter :sheet
end
