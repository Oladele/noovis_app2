require "acceptance_helper"

RSpec.resource "CableRuns" do
  header "Content-Type", "application/vnd.api+json"

  shared_context "cable-run parameters" do
    parameter :type,
      "Should always be set to <code>cable-runs</code>",
      required: true
    parameter :sheet, 
      "Sheet id", 
      required: true, scope: :relationships
    parameter :site,
      "Site", 
      scope: :attributes
    parameter :building,
      "Building", 
      scope: :attributes
    parameter :room,
      "Room", 
      scope: :attributes
    parameter :drop,
      "Drop", 
      scope: :attributes
    parameter :rdt,
      "RDT", 
      scope: :attributes
    parameter :rdt_port,
      "RDT Port", 
      scope: :attributes
    parameter :fdh_port,
      "FDH Port", 
      scope: :attributes
    parameter :splitter,
      "Splitter", 
      scope: :attributes
    parameter :splitter_fiber,
      "Splitter Fiber", 
      scope: :attributes
    parameter :pon_card,
      "PON Card", 
      scope: :attributes
    parameter :pon_port,
      "PON Port", 
      scope: :attributes
    parameter :fdh,
      "FDH", 
      scope: :attributes
    parameter :notes,
      "Notes", 
      scope: :attributes
    parameter :olt_rack,
      "OLT Rack", 
      scope: :attributes
    parameter :olt_chassis,
      "OLT Chassis", 
      scope: :attributes
    parameter :vam_shelf,
      "VAM Shelf", 
      scope: :attributes
    parameter :vam_module,
      "VAM Module", 
      scope: :attributes
    parameter :vam_port,
      "VAM Port", 
      "Backbone Shelf", 
      scope: :attributes
    parameter :backbone_cable,
      "Backbone Cable", 
      scope: :attributes
    parameter :backbone_port,
      "Backbone Port", 
      scope: :attributes
    parameter :fdh_location,
      "FDG Location", 
      scope: :attributes
    parameter :rdt_location,
      "RDT Location", 
      scope: :attributes
    parameter :ont_model,
      "ONT Model", 
      scope: :attributes
    parameter :ont_sn,
      "ONT SN", 
      scope: :attributes
    parameter :rdt_port_count,
      "RDT Port Count", 
      scope: :attributes
    parameter :ont_ge_1_device,
      "ONT GE 1 Device", 
      scope: :attributes
    parameter :ont_ge_1_mac,
      "ONT GE 1 MAC", 
      scope: :attributes
    parameter :ont_ge_2_device,
      "ONT GE 2 Device", 
      scope: :attributes
    parameter :ont_ge_2_mac,
      "ONT GE 2 MAC", 
      scope: :attributes
    parameter :ont_ge_3_device,
      "ONT GE 3 Device", 
      scope: :attributes
    parameter :ont_ge_3_mac,
      "ONT GE 3 MAC", 
      scope: :attributes
    parameter :ont_ge_4_device,
      "ONT GE 4 Device", 
      scope: :attributes
    parameter :ont_ge_4_mac,
      "ONT GE 4 MAC", 
      scope: :attributes

    let(:type){ "cable-runs"}
    let(:sheet_id){ (FactoryGirl.create(:sheet)).id }
    let(:sheet){{"data"=>{"type"=>"sheets", "id"=> sheet_id}}}
  end

  shared_context "for a persisted cable-run" do
    parameter :id, 
      "The id of the cable-run",
      required: true

    let(:persisted_cable_run){ FactoryGirl.create :cable_run  }
    let(:id){ persisted_cable_run.id.to_s }
    let(:cable_run_id){ persisted_cable_run.id.to_s }
  end

  post "/cable-runs" do
    include_context "cable-run parameters"

    let(:site){ "Site Name"}
    
    example_request "Create a network site" do
      expect(status).to eq 201
      cable_run = JSON.parse(response_body)
      expect(cable_run["data"]["attributes"]["site"]).to eq site
    end
  end

  patch "/cable-runs/:cable_run_id" do
    include_context "cable-run parameters"
    include_context "for a persisted cable-run"

    let(:site){ "Updated Site"}
    
    example_request "Update a cable-run" do
      expect(status).to eq 200
      cable_run = JSON.parse(response_body)
      expect(cable_run["data"]["attributes"]["site"]).to eq site
    end
  end

  get "/cable-runs" do
    before do
      FactoryGirl.create :cable_run
      FactoryGirl.create :cable_run
    end

    example_request "List all cable-runs" do
      expect(status).to eq 200
      cable_runs = JSON.parse(response_body)
      expect(cable_runs["data"].size).to eq 2
    end
  end

  delete "/cable-runs/:cable_run_id" do
    include_context "cable-run parameters"
    include_context "for a persisted cable-run"
    example_request "Delete a cable-run" do
      expect(status).to eq 204
    end
  end

end