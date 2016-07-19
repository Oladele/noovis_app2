require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = [:json, :combined_text, :html]
  config.api_name = "NNOA 2.0"

  # copied from json-api-example 
  # https://github.com/barelyknown/json-api-example
  # limits "Headers" and "Response" details to key values (much cleaner)
  config.request_headers_to_include = ["Content-Type", "Authorization", "Access-Token", "Client", "Uid"]
  config.response_headers_to_include = ["Content-Type", "access-token", "client", "uid"]
  config.curl_headers_to_filter = %w[Host Cookie]
  config.post_body_formatter = proc do |params|
    { data: params }.to_json if params.present?
  end

end
