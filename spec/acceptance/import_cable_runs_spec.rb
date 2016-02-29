require "acceptance_helper"

RSpec.resource "ImportCableRuns" do
  header "Accept", "*/*"
  header "Content-Type", "multipart/form-data"

  shared_context "import-cable-runs parameters" do
    #parameter :file,
    #  "Workbook File",
    #  required: true
    parameter :sheet,
      "Sheet Name",
      required: true
    parameter :building_id,
      "Building id",
      required: true

    #let(:file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test.xls'), 'application/vnd.ms-excel')}
    #file = File.new(File.join(Rails.root, 'spec', 'support', 'test.xls'))
    #let(:file) do
    #  ActionDispatch::Http::UploadedFile.new({
    #    tempfile: file,
    #    filename: File.basename(file),
    #    content_type: 'application/vnd.ms-excel'
    #  })
    #end
    let(:sheet) { 'Sheet1' }
    let(:building_id) { (FactoryGirl.create(:building)).id }
  end

  post "/import_cable_run" do
    include_context "import-cable-runs parameters"

    example_request "Upload sheet" do
      expect(status).to eq 201
    end
  end
end
