class SheetResource < JSONAPI::Resource
  attributes :name
  has_one :workbook
  has_one :building

  filters :workbook, :building
end
