require "acceptance_helper"

RSpec.resource "Users" do
 header "Content-Type", "application/vnd.api+json"

 shared_context "user parameters" do
   parameter :"company", 
     "Company id", 
     required: true, scope: :relationships
   parameter :type,
     "Should always be set to <code>users</code>",
     required: true
   parameter :email, 
     "User email", 
     required: true, scope: :attributes

   let(:type){ "users"}
   let(:company_id){ (FactoryGirl.create(:company)).id }
   let(:company){{"data"=>{"type"=>"companies", "id"=> company_id}}}
 end

 shared_context "for a persisted user" do
   parameter :id, 
     "The id of the user",
     required: true

   let(:persisted_user){ FactoryGirl.create :user  }
   let(:id){ persisted_user.id.to_s }
   let(:user_id){ persisted_user.id.to_s }
 end

 post "/users" do
   include_context "user parameters"

   let(:email){ "test@example.com"}
   
   example_request "Create a user" do
     expect(status).to eq 201
     network_site = JSON.parse(response_body)
     expect(network_site["data"]["attributes"]["email"]).to eq email
   end
 end

 patch "/users/:user_id" do
   include_context "user parameters"
   include_context "for a persisted user"

   let(:email){ "updated@example.com"}
   
   example_request "Update a user" do
     expect(status).to eq 200
     user = JSON.parse(response_body)
     expect(user["data"]["attributes"]["email"]).to eq email
   end
 end

 get "/users" do
   before do
     FactoryGirl.create :user, email: "test1@example.com"
     FactoryGirl.create :user, email: "test2@example.com"
   end

   example_request "List all users" do
     expect(status).to eq 200
     users = JSON.parse(response_body)
     expect(users["data"].size).to eq 2
   end
 end

 delete "/users/:user_id" do
   include_context "user parameters"
   include_context "for a persisted user"
   example_request "Delete a user" do
     expect(status).to eq 204
   end
 end

end
