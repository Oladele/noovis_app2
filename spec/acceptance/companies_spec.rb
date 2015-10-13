require "acceptance_helper"

RSpec.resource "Companies" do
  header "Content-Type", "application/vnd.api+json"

  post "/companies" do
  	parameter :type, <<-DESC, required: true
      Should always be set to <code>companies</code>.
    DESC
    parameter :name, 
    	"Company Name", 
    	required: true, scope: :attributes

    let(:type){ "companies"}
    let(:name){ "ACME Company"}
    
    example "Create a company" do
    	do_request
    	expect(status).to eq 201
    end
  end

  get "/companies" do    
    example "List all companies" do
    	FactoryGirl.create :company, name: "1st company"
    	FactoryGirl.create :company, name: "2nd company"
      do_request
      expect(status).to eq 200
    end
  end

end