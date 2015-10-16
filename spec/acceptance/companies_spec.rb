require "acceptance_helper"

RSpec.resource "Companies" do
  header "Content-Type", "application/vnd.api+json"

  shared_context "company parameters" do
    parameter :type,
      "Should always be set to <code>companies</code>",
      required: true
    parameter :name, 
      "Company Name", 
      required: true, scope: :attributes

    let(:type){ "companies"}
  end

  post "/companies" do
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

    parameter :id, 
      "The id of the company",
      required: true

    let(:persisted_company){ FactoryGirl.create :company  }
    let(:id){ persisted_company.id.to_s }
    let(:company_id){ persisted_company.id.to_s }
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
      expect(companies["data"].size).to eq 2
    end
  end

end