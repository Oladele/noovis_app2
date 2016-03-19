class SheetResource < JSONAPI::Resource
  attributes :name, :created_at, :updated_at
  has_one :workbook
  has_one :building
  has_many :cable_runs
  has_many :network_graphs

  filters :workbook, :building
end
