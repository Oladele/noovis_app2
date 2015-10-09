require "rails_helper"
require 'rspec_api_documentation/dsl'

RSpec.resource "Companies" do
  get "/companies" do
    example "Listing companies" do
      do_request

      expect(status).to eq 200
    end
  end
end