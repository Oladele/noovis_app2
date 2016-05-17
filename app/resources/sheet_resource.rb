class SheetResource < JSONAPI::Resource
  attributes :name, :created_at, :updated_at, :record_count, :versions
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

  def versions
    PaperTrail::Version.where("item_type = ? AND sheet_id = ?", "CableRun", @model.id)
      .order(created_at: :desc)
      .map do |version|
      user_email = version.whodunnit ? User.find(version.whodunnit).email : 'unknown'

      {
        user: { id: version.whodunnit, email: user_email },
        cable_run: { id: version.item.id, ont_sn: version.item.ont_sn },
        event_type: version.event,
        changes: version.changeset
      }
    end
  end
end
