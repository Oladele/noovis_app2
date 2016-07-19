require "acceptance_helper"

RSpec.resource "ImportCableRuns" do
  header "Accept", "*/*"
  header "Content-Type", "multipart/form-data"

  before do
    user_headers = FactoryGirl.create(:user, role: :admin).create_new_auth_token
    header "Access-Token", user_headers["access-token"]
    header "Client", user_headers["client"]
    header "Uid", user_headers["uid"]
    header "Token-Type", user_headers["Bearer"]
    header "Expiry", user_headers["expiry"]
  end

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
