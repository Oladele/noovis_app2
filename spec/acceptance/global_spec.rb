require "acceptance_helper"

RSpec.resource "Global" do
 header "Content-Type", "application/vnd.api+json"

  before do
    user_headers = FactoryGirl.create(:user).create_new_auth_token
    header "Access-Token", user_headers["access-token"]
    header "Client", user_headers["client"]
    header "Uid", user_headers["uid"]
    header "Token-Type", user_headers["Bearer"]
    header "Expiry", user_headers["expiry"]
  end

 let(:type) { "global" }
 let(:global) { Global.new }

 get "/global" do
   example_request "List Global Attributes" do
     expect(status).to eq 200
     global = JSON.parse(response_body)
     expect(global["data"]["attributes"]["node-counts"].first["node_type"]).to eq "network-sites"
   end
 end
end
