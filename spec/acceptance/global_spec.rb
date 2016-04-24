#require "acceptance_helper"
#
#RSpec.resource "Global" do
# header "Content-Type", "application/vnd.api+json"
#
# let(:type) { "global" }
# let(:global) { Global.new }
#
# get "/global" do
#   example_request "List Global Attributes" do
#     expect(status).to eq 200
#     global = JSON.parse(response_body)
#     expect(global["data"]["attributes"]["node-counts"].first["node_type"]).to eq "network-sites"
#   end
# end
#end
