require "acceptance_helper"

RSpec.resource "ImportCableRuns" do
  header "Accept", "*/*"
  header "Content-Type", "multipart/form-data"

  shared_context "import-cable-runs parameters" do
    parameter :file,
      "Workbook File",
      required: true,
      type: "Multipart/Form-data"
    parameter :sheet,
      "Sheet Name",
      required: true,
      type: "Multipart/Form-data"
    parameter :building_id,
      "Building id",
      required: true,
      type: "Multipart/Form-data"

    let(:file) do 
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, 'spec', 'support', 'test.xls'),
        content_type: 'application/vnd.ms-excel'
      )
    end
    let(:sheet) { 'Sheet1' }
    let(:building_id) { (FactoryGirl.create(:building)).id }

    let(:raw_post) { params }

  end

  post "/import_cable_run" do
    include_context "import-cable-runs parameters"

    example_request "Upload sheet" do
      expect(status).to eq 201
    end
  end
end
