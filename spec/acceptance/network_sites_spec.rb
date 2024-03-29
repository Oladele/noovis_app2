require "acceptance_helper"

RSpec.resource "NetworkSites" do
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
    parameter :type,
      "Should always be set to <code>network-sites</code>",
      required: true
    parameter :company, 
      "Company id", 
      required: true, scope: :relationships
    parameter :name, 
      "Network Site Name", 
      required: true, scope: :attributes
    parameter :lat,
      "Network Site Latitude",
      scope: :attributes
    parameter :lng,
      "Network Site Longitude",
      scope: :attributes
    parameter :address,
      "Address Field",
      scope: :attributes

    let(:type){ "network-sites"}
    let(:company_id){ (FactoryGirl.create(:company)).id }
    let(:company){{"data"=>{"type"=>"companies", "id"=> company_id}}}
  end

  shared_context "for a persisted network-site" do
    parameter :id, 
      "The id of the network-site",
      required: true

    let(:persisted_network_site){ FactoryGirl.create :network_site  }
    let(:id){ persisted_network_site.id.to_s }
    let(:network_site_id){ persisted_network_site.id.to_s }
  end

  post "/network-sites" do
    include_context "network-site parameters"

    let(:name){ "Site Name"}
    
    example_request "Create a network site" do
      expect(status).to eq 201
      network_site = JSON.parse(response_body)
      expect(network_site["data"]["attributes"]["name"]).to eq name
    end
  end

  patch "/network-sites/:network_site_id" do
    include_context "network-site parameters"
    include_context "for a persisted network-site"

    let(:name){ "Updated Network Site Name"}
    
    example_request "Update a network-site" do
      expect(status).to eq 200
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
      expect(network_sites["data"].first["attributes"]["node-counts"].first["node_type"]).to eq "buildings"
    end
  end

  delete "/network-sites/:network_site_id" do
    include_context "network-site parameters"
    include_context "for a persisted network-site"
    example_request "Delete a network-site" do
      expect(status).to eq 204
    end
  end

end
