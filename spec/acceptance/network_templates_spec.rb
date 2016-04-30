require "acceptance_helper"

RSpec.resource "NetworkTemplates" do
  header "Content-Type", "application/vnd.api+json"

  before do
    user_headers = FactoryGirl.create(:user).create_new_auth_token
    header "Access-Token", user_headers["access-token"]
    header "Client", user_headers["client"]
    header "Uid", user_headers["uid"]
    header "Token-Type", user_headers["Bearer"]
    header "Expiry", user_headers["expiry"]
  end

  shared_context "network-template parameters" do
    parameter :type,
      "Should always be set to <code>network-templates</code>",
      required: true
    parameter :name, 
      "Network Template Name", 
      required: true, scope: :attributes
    parameter :description,
      "Network Template Description",
      scope: :attributes
    parameter :hierarchy,
      "Network Template Hierarchy",
      scope: :attributes

    let(:type){ "network-templates"}
  end

  shared_context "for a persisted network-template" do
    parameter :id, 
      "The id of the network-template",
      required: true

    let(:persisted_network_template){ FactoryGirl.create :network_template  }
    let(:id){ persisted_network_template.id.to_s }
    let(:network_template_id){ persisted_network_template.id.to_s }
  end

  post "/network-templates" do
    include_context "network-template parameters"

    let(:name){ "Template Name"}
    
    example_request "Create a network template" do
      expect(status).to eq 201
      network_template = JSON.parse(response_body)
      expect(network_template["data"]["attributes"]["name"]).to eq name
    end
  end

  patch "/network-templates/:network_template_id" do
    include_context "network-template parameters"
    include_context "for a persisted network-template"

    let(:name){ "Updated Network Template Name"}
    
    example_request "Update a network-template" do
      expect(status).to eq 200
      network_template = JSON.parse(response_body)
      expect(network_template["data"]["attributes"]["name"]).to eq name
    end
  end

  get "/network-templates" do
    before do
      FactoryGirl.create :network_template, name: "1st template"
      FactoryGirl.create :network_template, name: "2nd template"
    end

    example_request "List all network-templates" do
      expect(status).to eq 200
      network_templates = JSON.parse(response_body)
      expect(network_templates["data"].size).to eq 2
    end
  end

  delete "/network-templates/:network_template_id" do
    include_context "network-template parameters"
    include_context "for a persisted network-template"
    example_request "Delete a network-template" do
      expect(status).to eq 204
    end
  end

end
