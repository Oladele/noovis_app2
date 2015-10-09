require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Companies" do
  get "/Companies" do
    example "Listing companies" do
      do_request

      status.should == 200
    end
  end
end