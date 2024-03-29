require "acceptance_helper"

RSpec.resource "Companies" do
  header "Content-Type", "application/vnd.api+json"

  before do
    user_headers = FactoryGirl.create(:user).create_new_auth_token
    header "Access-Token", user_headers["access-token"]
    header "Client", user_headers["client"]
    header "Uid", user_headers["uid"]
    header "Token-Type", user_headers["Bearer"]
    header "Expiry", user_headers["expiry"]
  end

  shared_context "company parameters" do
    parameter :type,
      "Should always be set to <code>companies</code>",
      required: true
    parameter :name, 
      "Company Name", 
      required: true, scope: :attributes

    let(:type){ "companies"}
  end

  shared_context "for a persisted company" do
    parameter :id, 
      "The id of the company",
      required: true

    let(:persisted_company){ FactoryGirl.create :company  }
    let(:id){ persisted_company.id.to_s }
    let(:company_id){ persisted_company.id.to_s }
  end

  post "/companies", @auth_headers do
    include_context "company parameters"

    let(:name){ "ACME Company"}
    
    example_request "Create a company" do
    	expect(status).to eq 201
      company = JSON.parse(response_body)
      expect(company["data"]["attributes"]["name"]).to eq name
    end
  end

  patch "/companies/:company_id" do
    include_context "company parameters"
    include_context "for a persisted company"

    let(:name){ "New Company Name"}
    
    example_request "Update a company" do
      expect(status).to eq 200
      company = JSON.parse(response_body)
      expect(company["data"]["attributes"]["name"]).to eq name
    end
  end

  get "/companies" do    
    before do
    	FactoryGirl.create :company, name: "1st company"
    	FactoryGirl.create :company, name: "2nd company"
    end
    
    example_request "List all companies" do
      expect(status).to eq 200
      companies = JSON.parse(response_body)
    	# third company from user creation
      expect(companies["data"].size).to eq 3
      expect(companies["data"].first["attributes"]["node-counts"].first["node_type"]).to eq "network-sites"
    end
  end

  delete "/companies/:company_id" do
    include_context "company parameters"
    include_context "for a persisted company"
    example_request "Delete a company" do
      expect(status).to eq 204
    end
  end

end
