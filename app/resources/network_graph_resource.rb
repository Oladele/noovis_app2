class NetworkGraphResource < JSONAPI::Resource
  has_one :sheet
  has_one :network_template

  filter :sheet
end
