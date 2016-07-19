# == Schema Information
#
# Table name: cable_runs
#
#  id              :integer          not null, primary key
#  site            :string
#  building        :string
#  room            :string
#  drop            :string
#  rdt             :string
#  rdt_port        :string
#  fdh_port        :string
#  splitter        :string
#  splitter_fiber  :string
#  sheet_id        :integer
#  pon_card        :string
#  pon_port        :string
#  fdh             :string
#  notes           :text
#  olt_rack        :string
#  olt_chassis     :string
#  vam_shelf       :string
#  vam_module      :string
#  vam_port        :string
#  backbone_shelf  :string
#  backbone_cable  :string
#  backbone_port   :string
#  fdh_location    :string
#  rdt_location    :string
#  ont_model       :string
#  ont_sn          :string
#  rdt_port_count  :string
#  ont_ge_1_device :string
#  ont_ge_1_mac    :string
#  ont_ge_2_device :string
#  ont_ge_2_mac    :string
#  ont_ge_3_device :string
#  ont_ge_3_mac    :string
#  ont_ge_4_device :string
#  ont_ge_4_mac    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class CableRun < ActiveRecord::Base
  belongs_to :sheet
  has_one :company, through: :sheet
  has_paper_trail meta: { sheet_id: :sheet_id }

  def ont_node_id
    # building = sheet.building
    # network_graph = NetworkGraph.latest_for building
    # if network_graph
    #   building_nodes = network_graph.nodes
    #   ont_node = building_nodes.find_by node_type: "ont_sn"
    #   if ont_node
    #     ont_node.id
    #   else
    #     nil
    #   end
    # else
    #   nil
    # end
  end

  def self.header_to_fields(header)
    fields = {
      extra: [],
      extra_friendlies: [],
      missing: [],
      missing_friendlies: [],
      valid: [],
      valid_indices: [],
      valid_friendlies: []
    }
    list = CableRun.attr_names_expected

    header.each_with_index do |name, index|
      attribute = name_to_attr name
      if list.include? attribute
        fields[:valid] << attribute
        fields[:valid_friendlies] << friendly_names[attribute]
        fields[:valid_indices] << index

      else
        fields[:extra] << name
        fields[:extra_friendlies] << name
      end
    end

    fields[:missing] = list.reject{|field| fields[:valid].include?(field) }
    friendly_names.each_value do |friendly_name|
      unless fields[:valid_friendlies].include?(friendly_name)
        fields[:missing_friendlies] << friendly_name
      end
    end

    fields
  end

  def self.attr_names_expected
    internal_attrs = %w(id created_at updated_at sheet_id)
    attribute_names.reject { |attr| internal_attrs.include? attr }
  end

  def self.name_to_attr(name)
    stripped_name = name.downcase.strip if name

    if attr_names_expected.include? stripped_name
      return stripped_name
    end

    case stripped_name
      # TODO: Can probably use gsub here to take out the spaces and remove the case statement.
      when "Site".downcase.strip
        "site"
      when "Building".downcase.strip
        "building"
      when "OLT Rack".downcase.strip
        "olt_rack"
      when "OLT Chassis".downcase.strip
        "olt_chassis"
      when "PON Card".downcase.strip
        "pon_card"
      when "PON Port".downcase.strip
        "pon_port"
      when "VAM Shelf".downcase.strip
        "vam_shelf"
      when "VAM Module".downcase.strip
        "vam_module"
      when "VAM Port".downcase.strip
        "vam_port"
      when "Backbone Shelf".downcase.strip
        "backbone_shelf"
      when "Backbone Cable".downcase.strip
        "backbone_cable"
      when "Backbone Port".downcase.strip
        "backbone_port"
      when "FDH".downcase.strip
        "fdh"
      when "FDH Location".downcase.strip
        "fdh_location"
      when "Splitter".downcase.strip
        "splitter"
      when "Splitter Fiber".downcase.strip
        "splitter_fiber"
      when "FDH Port".downcase.strip
        "fdh_port"
      when "RDT".downcase.strip
        "rdt"
      when "RDT Location".downcase.strip
        "rdt_location"
      when "RDT Port".downcase.strip
        "rdt_port"
      when "Drop #".downcase.strip
        "drop"
      when "Room Number".downcase.strip
        "room"
      when "ONT Model".downcase.strip
        "ont_model"
      when "ONT SN#".downcase.strip
        "ont_sn"
      when "Notes".downcase.strip
        "notes"
      when "RDT Port Count".downcase.strip
          "rdt_port_count"
      when "ONT GE Port 1 Device".downcase.strip
          "ont_ge_1_device"
      when "ONT GE Port 1 Mac".downcase.strip
          "ont_ge_1_mac"
      when "ONT GE Port 2 Device".downcase.strip
          "ont_ge_2_device"
      when "ONT GE Port 2 Mac".downcase.strip
          "ont_ge_2_mac"
      when "ONT GE Port 3 Device".downcase.strip
          "ont_ge_3_device"
      when "ONT GE Port 3 Mac".downcase.strip
          "ont_ge_3_mac"
      when "ONT GE Port 4 Device".downcase.strip
          "ont_ge_4_device"
      when "ONT GE Port 4 Mac".downcase.strip
          "ont_ge_4_mac"
      when "Floor".downcase.strip
          "floor"
      else
        "UNIDENTIFIED"
    end
  end

  def self.friendly_names
    {
      "site" => "Site",
      "building" => "Building",
      "olt_rack" => "OLT Rack",
      "olt_chassis" => "OLT Chassis",
      "pon_card" => "PON Card",
      "pon_port" => "PON Port",
      "vam_shelf" => "VAM Shelf",
      "vam_module" => "VAM Module",
      "vam_port" => "VAM Port",
      "backbone_shelf" => "Backbone Shelf",
      "backbone_cable" => "Backbone Cable",
      "backbone_port" => "Backbone Port",
      "fdh" => "FDH",
      "fdh_location" => "FDH Location",
      "splitter" => "Splitter",
      "splitter_fiber" => "Splitter Fiber",
      "fdh_port" => "FDH Port",
      "rdt" => "RDT",
      "rdt_location" => "RDT Location",
      "rdt_port" => "RDT Port",
      "drop" => "Drop #",
      "room" => "Room Number",
      "ont_model" => "ONT Model",
      "ont_sn" => "ONT SN#",
      "notes" => "Notes",
      "rdt_port_count" => "RDT Port Count",
      "ont_ge_1_device" => "ONT GE Port 1 Device",
      "ont_ge_1_mac" => "ONT GE Port 1 MAC",
      "ont_ge_2_device" => "ONT GE Port 2 Device",
      "ont_ge_2_mac" => "ONT GE Port 2 MAC",
      "ont_ge_3_device" => "ONT GE Port 3 Device",
      "ont_ge_3_mac" => "ONT GE Port 3 MAC",
      "ont_ge_4_device" => "ONT GE Port 4 Device",
      "ont_ge_4_mac" => "ONT GE Port 4 MAC",
      "floor" => "Floor"
    }
  end
end
