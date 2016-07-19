require "acceptance_helper"

RSpec.resource "NetworkSiteStats" do
 header "Content-Type", "application/vnd.api+json"

  before do
    user_headers = FactoryGirl.create(:user).create_new_auth_token
    header "Access-Token", user_headers["access-token"]
    header "Client", user_headers["client"]
    header "Uid", user_headers["uid"]
    header "Token-Type", user_headers["Bearer"]
    header "Expiry", user_headers["expiry"]
  end

 shared_context "network-site parameters" do
   parameter :"network-site",
     "Network site id",
     required: true, scope: :relationships

   let(:id){ (FactoryGirl.create(:network_site_with_buildings)).id }
 end

 get "network-sites/:id/chart-distribution-ports-buildings" do
   include_context "network-site parameters"

   example_request "gets" do
     expect(status).to eq 200
   end
 end

 get "network-sites/:id/chart-distribution-ports-site" do
   include_context "network-site parameters"

   example_request "gets" do
     expect(status).to eq 200
   end
 end

 get "network-sites/:id/chart-feeder-capacity-buildings" do
   include_context "network-site parameters"

   example_request "gets" do
     expect(status).to eq 200
   end
 end

 get "network-sites/:id/chart-feeder-capacity-site" do
   include_context "network-site parameters"

   example_request "gets" do
     expect(status).to eq 200
   end
 end

 get "network-sites/:id/chart-pon-usage-buildings" do
   include_context "network-site parameters"

   example_request "gets" do
     expect(status).to eq 200
   end
 end

 get "network-sites/:id/chart-pon-usage-site" do
   include_context "network-site parameters"

   example_request "gets" do
     expect(status).to eq 200
   end
 end

 get "network-sites/:id/network-element-counts" do
   include_context "network-site parameters"

   example_request "gets" do
     expect(status).to eq 200
   end
 end

 get "network-sites/:id/chart-distribution-spares-buildings" do
   include_context "network-site parameters"

   example_request "gets" do
     expect(status).to eq 200
   end
 end
end
