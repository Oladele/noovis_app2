class CableRunResource < JSONAPI::Resource
  attributes :site,
    :building,
    :room,
    :drop,
    :rdt,
    :rdt_port,
    :fdh_port,
    :splitter,
    :splitter_fiber,
    :pon_card,
    :pon_port,
    :fdh,
    :notes,
    :olt_rack,
    :olt_chassis,
    :vam_shelf,
    :vam_module,
    :vam_port,
    :backbone_shelf,
    :backbone_cable,
    :backbone_port,
    :fdh_location,
    :rdt_location,
    :ont_model,
    :ont_sn,
    :rdt_port_count,
    :ont_ge_1_device,
    :ont_ge_1_mac,
    :ont_ge_2_device,
    :ont_ge_2_mac,
    :ont_ge_3_device,
    :ont_ge_3_mac,
    :ont_ge_4_device,
    :ont_ge_4_mac,
    :ont_node_id,
    :versions
  has_one :sheet

  filter :sheet

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      CableRun.includes(:company).where(companies: {id: current_user.company_id}).references(:company)
    else
      super
    end
  end

  def self.updatable_fields(context)
    super - [:ont_node_id]
  end

  def self.creatable_fields(context)
    super - [:ont_node_id]
  end

  def versions
    @model.versions.map do |version|
      user_email = version.whodunnit ? User.find(version.whodunnit).email : 'unknown'

      {
        user: { id: version.whodunnit, email: user_email },
        event_type: version.event,
        changes: version.changeset
      }
    end
  end
end
