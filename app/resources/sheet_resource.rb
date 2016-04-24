class SheetResource < JSONAPI::Resource
  attributes :name, :created_at, :updated_at, :record_count
  has_one :workbook
  has_one :building
  has_many :cable_runs
  has_many :network_graphs

  filters :workbook, :building

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      Sheet.includes(:company).where(companies: {id: current_user.company_id}).references(:company)
    else
      super
    end
  end
end
