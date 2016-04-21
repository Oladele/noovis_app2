require "acceptance_helper"

RSpec.resource "Authorize user token" do
  #header "Content-Type", "application/json"
  #header "Accept", "application/json"

  #shared_context "persisted user" do
  #  let(:user) { FactoryGirl.create :user, email: 'testuser@example.com',
  #    password: 'password', password_confirmation: 'password' }

  #  let(:email) { 'testuser@example.com' }
  #  let(:password) { 'password' }
  #end

  #shared_context "auth parameters" do
  #  parameter :email, 
  #    "User email address", 
  #    required: true
  #  parameter :password,
  #    "User password", 
  #    required: true
  #end

  #post "/auth/sign_in" do
  #  include_context "persisted user"
  #  include_context "auth parameters"

  #  example_request "Sign in user", email: 'testuser@example.com', password: 'password' do
  #    expect(status).to eq 200
  #    user = JSON.parse(response_body)
  #    expect(user["data"]["email"]).to eq email
  #  end
  #end
end
