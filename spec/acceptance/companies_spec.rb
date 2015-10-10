require "acceptance_helper"

RSpec.resource "Companies" do
  header "Content-Type", "application/vnd.api+json"

  get "/companies" do
    
    example "Listing companies" do
    	FactoryGirl.create :company, name: "1st company"
    	FactoryGirl.create :company, name: "2nd company"
      do_request

      expect(status).to eq 200
    end
  end
end