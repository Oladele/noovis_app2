require "acceptance_helper"

RSpec.resource "Buildings" do
 header "Content-Type", "application/vnd.api+json"

  before do
    user_headers = FactoryGirl.create(:user).create_new_auth_token
    header "Access-Token", user_headers["access-token"]
    header "Client", user_headers["client"]
    header "Uid", user_headers["uid"]
    header "Token-Type", user_headers["Bearer"]
    header "Expiry", user_headers["expiry"]
  end

 shared_context "building parameters" do
   parameter :"network-site", 
     "Network site id", 
     required: true, scope: :relationships
   parameter :type,
     "Should always be set to <code>buildings</code>",
     required: true
   parameter :name, 
     "Building Name", 
     required: true, scope: :attributes
    parameter :lat,
      "Building Latitude",
      scope: :attributes
    parameter :lng,
      "Building Longitude",
      scope: :attributes

   let(:type){ "buildings"}
   let(:network_site_id){ (FactoryGirl.create(:network_site)).id }
   let(:"network-site"){{"data"=>{"type"=>"network-sites", "id"=> network_site_id}}}
 end

 shared_context "for a persisted building" do
   parameter :id, 
     "The id of the building",
     required: true

   let(:persisted_building){ FactoryGirl.create :building  }
   let(:id){ persisted_building.id.to_s }
   let(:building_id){ persisted_building.id.to_s }
 end

 post "/buildings" do
   include_context "building parameters"

   let(:name){ "Building Name"}
   
   example_request "Create a building" do
     expect(status).to eq 201
     network_site = JSON.parse(response_body)
     expect(network_site["data"]["attributes"]["name"]).to eq name
   end
 end

 patch "/buildings/:building_id" do
   include_context "building parameters"
   include_context "for a persisted building"

   let(:name){ "Updated Building Name"}
   
   example_request "Update a building" do
     expect(status).to eq 200
     building = JSON.parse(response_body)
     expect(building["data"]["attributes"]["name"]).to eq name
   end
 end

 get "/buildings" do
   before do
     FactoryGirl.create :building, name: "1st building"
     FactoryGirl.create :building, name: "2nd building"
   end

   example_request "List all buildings" do
     expect(status).to eq 200
     buildings = JSON.parse(response_body)
     expect(buildings["data"].size).to eq 2
   end
 end

 delete "/buildings/:building_id" do
   include_context "building parameters"
   include_context "for a persisted building"
   example_request "Delete a building" do
     expect(status).to eq 204
   end
 end

end
