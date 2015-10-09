require "acceptance_helper"

RSpec.resource "Companies" do
  get "/companies" do
    example "Listing companies" do
      do_request

      expect(status).to eq 200
    end
  end
end