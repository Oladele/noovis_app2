class CableRunResource < JSONAPI::Resource
  has_one :sheet

  filter :sheet
end
