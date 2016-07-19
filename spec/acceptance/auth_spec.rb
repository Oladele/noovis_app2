require "acceptance_helper"

RSpec.resource "Auth" do
  header "Content-Type", "application/json"

  shared_context "auth parameters" do
    parameter :email, 
      "User email", 
      required: true
    parameter :password,
      "User password",
      required: true

    let(:email){ "test@example.com"}
    let(:password){ "password" }
    let(:raw_post) { params.to_json }
  end

  post "/auth/sign_in" do
    before do
      FactoryGirl.create(:user, email: 'test@example.com', password: 'password')
    end

    include_context "auth parameters"

    example_request "Sign in user" do
      expect(response_headers).to include "access-token"
      expect(status).to eq 200
      user = JSON.parse(response_body)
      expect(user["data"]["email"]).to eq email
    end
  end

  delete "/auth/sign_out" do
    before do
      user_headers = FactoryGirl.create(:user, email: 'test@example.com', password: 'password').create_new_auth_token
      header "Access-Token", user_headers["access-token"]
      header "Client", user_headers["client"]
      header "Uid", user_headers["uid"]
      header "Token-Type", user_headers["Bearer"]
      header "Expiry", user_headers["expiry"]
    end

    example_request "Sign out user" do
      headers
      expect(status).to eq 200
    end
  end
end
