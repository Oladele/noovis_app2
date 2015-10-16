require "acceptance_helper"

RSpec.resource "NetworkSites" do
  header "Content-Type", "application/vnd.api+json"

  shared_context "network-site parameters" do
    parameter :type,
      "Should always be set to <code>network-sites</code>",
      required: true
    parameter :company, 
      "Company id", 
      required: true, scope: :relationships
    parameter :name, 
      "Network Site Name", 
      required: true, scope: :attributes

    let(:type){ "network-sites"}
  end

  post "/network-sites" do
    include_context "network-site parameters"

    let(:name){ "Site Name"}
    let(:company_id){ (FactoryGirl.create(:company)).id }
    let(:company){{"data"=>{"type"=>"companies", "id"=> company_id}}}
    
    example_request "Create a network site" do
      expect(status).to eq 201
      network_site = JSON.parse(response_body)
      expect(network_site["data"]["attributes"]["name"]).to eq name
    end
  end

  get "/network-sites" do

    before do
      FactoryGirl.create :network_site, name: "1st site"
      FactoryGirl.create :network_site, name: "2nd site"
    end

    example_request "List all network-sites" do
      expect(status).to eq 200
      network_sites = JSON.parse(response_body)
      expect(network_sites["data"].size).to eq 2
    end
  end

end