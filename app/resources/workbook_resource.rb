class WorkbookResource < JSONAPI::Resource
  attributes :name
  has_one :network_site
  has_many :sheets

  filter :network_site

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      Workbook.includes(:company).where(companies: {id: current_user.company_id}).references(:company)
    else
      super
    end
  end
end
