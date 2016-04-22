#require "acceptance_helper"
#
#RSpec.resource "Workbooks" do
# header "Content-Type", "application/vnd.api+json"
#
# shared_context "workbook parameters" do
#   parameter :"network-site",
#     "Network site id",
#     required: true, scope: :relationships
#   parameter :type,
#     "Should always be set to <code>workbooks</code>",
#     required: true
#   parameter :name,
#     "Workbook Name",
#     required: true, scope: :attributes
#
#   let(:type){ "workbooks" }
#   let(:network_site_id){ FactoryGirl.create(:network_site).id }
#   let(:"network-site"){{ data: {type: "network-sites", id: network_site_id }}}
# end
#
# shared_context "for a persisted workbook" do
#   parameter :id,
#     "The id of the workbook",
#     required: true
#
#   let(:persisted_workbook){ FactoryGirl.create :workbook }
#   let(:id){ persisted_workbook.id.to_s }
#   let(:workbook_id){ persisted_workbook.id.to_s }
# end
#
# post "/workbooks" do
#   include_context "workbook parameters"
#   
#   let(:name){ "Workbook Name" }
#
#   example_request "Create a workbook" do
#     expect(status).to eq 201
#     network_site = JSON.parse(response_body)
#     expect(network_site["data"]["attributes"]["name"]).to eq name
#   end
# end
#
# patch "/workbooks/:workbook_id" do
#   include_context "workbook parameters"
#   include_context "for a persisted workbook"
#
#   let(:name){ "Updated Workbook Name" }
#
#   example_request "Update a workbook" do
#     expect(status).to eq 200
#     workbook = JSON.parse(response_body)
#     expect(workbook["data"]["attributes"]["name"]).to eq name
#   end
# end
#
# get "/workbooks" do
#   before do
#     FactoryGirl.create :workbook, name: "1st workbook"
#     FactoryGirl.create :workbook, name: "2nd workbook"
#   end
#
#   example_request "List all workbooks" do
#     expect(status).to eq 200
#     workbooks = JSON.parse(response_body)
#     expect(workbooks["data"].size).to eq 2
#   end
# end
#
# delete "/workbooks/:workbook_id" do
#   include_context "workbook parameters"
#   include_context "for a persisted workbook"
#   example_request "Delete a workbook" do
#     expect(status).to eq 204
#   end
# end
#end
