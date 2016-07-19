require "acceptance_helper"

RSpec.resource "Sheets" do
  header "Content-Type", "application/vnd.api+json"

  before do
    user_headers = FactoryGirl.create(:user).create_new_auth_token
    header "Access-Token", user_headers["access-token"]
    header "Client", user_headers["client"]
    header "Uid", user_headers["uid"]
    header "Token-Type", user_headers["Bearer"]
    header "Expiry", user_headers["expiry"]
  end

  shared_context "sheet parameters" do
    parameter :workbook,
      "Workbook id",
      required: true, scope: :relationships
    parameter :building,
      "Building id",
      required: true, scope: :relationships
    parameter :type,
      "Should always be set to <code>sheets</code>",
      required: true
    parameter :name,
      "Sheet Name",
      required: true, scope: :attributes
    parameter :"created-at",
      "Sheet created at",
      scope: :attributes
    parameter :"updated-at",
      "Sheet created at",
      scope: :attributes
    parameter :"record-count",
      "Cable Run count for Sheet",
      scope: :attributes

    let(:type){ "sheets" }
    let(:workbook_id){ FactoryGirl.create(:workbook).id }
    let(:building_id){ FactoryGirl.create(:building).id }
    let(:workbook){{ data: { type: "workbooks", id: workbook_id }}}
    let(:building){{ data: { type: "buildings", id: building_id }}}
  end

  shared_context "for a persisted sheet" do
    parameter :id,
      "The id of the sheet",
      required: true

    let(:persisted_sheet){ FactoryGirl.create :sheet }
    let(:id){ persisted_sheet.id.to_s }
    let(:sheet_id){ persisted_sheet.id.to_s }
  end

  post "/sheets" do
    include_context "sheet parameters"

    let(:name){ "Sheet Name" }

    example_request "Create a sheet" do
      expect(status).to eq 201
      sheet = JSON.parse(response_body)
      expect(sheet["data"]["attributes"]["name"]).to eq name
    end
  end

  patch "/sheets/:sheet_id" do
    include_context "sheet parameters"
    include_context "for a persisted sheet"

    let(:name){ "Updated Sheet Name" }

    example_request "Update a sheet" do
      expect(status).to eq 200
      sheet = JSON.parse(response_body)
      expect(sheet["data"]["attributes"]["name"]).to eq name
    end
  end

  get "/sheets" do
    before do
      FactoryGirl.create :sheet, name: "1st sheet"
      FactoryGirl.create :sheet, name: "2nd sheet"
    end

    example_request "List all sheets" do
      expect(status).to eq 200
      sheets = JSON.parse(response_body)
      expect(sheets["data"].size).to eq 2
    end
  end

  delete "/sheets/:sheet_id" do
    include_context "sheet parameters"
    include_context "for a persisted sheet"
    example_request "Delete a sheet" do
      expect(status).to eq 204
    end
  end
end
