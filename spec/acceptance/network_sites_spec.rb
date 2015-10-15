require "acceptance_helper"

RSpec.resource "NetworkSites" do
  header "Content-Type", "application/vnd.api+json"

  get "/network-sites" do    
    example "List all network-sites" do
    	FactoryGirl.create :network_site, name: "1st site"
    	FactoryGirl.create :network_site, name: "2nd site"
      do_request
      expect(status).to eq 200
    end
  end

  post "/network-sites" do
    parameter :type,
      "Should always be set to <code>network-sites</code>",
      required: true
    parameter :name, 
      "Network Site Name", 
      required: true, scope: :attributes

    let(:type){ "network-sites"}
    let(:name){ "Site Name"}
    
    example "Create a network site" do
      do_request
      expect(status).to eq 201
    end
  end

end