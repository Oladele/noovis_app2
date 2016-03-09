require "acceptance_helper"

RSpec.resource "NodeTypes" do
  header "Content-Type", "application/vnd.api+json"

  shared_context "node-type parameters" do
    parameter :type,
      "Should always be set to <code>node-types</code>",
      required: true
    parameter :name, 
      "Node Type Name", 
      required: true, scope: :attributes
    parameter :picture,
      "Node Type Picture URL",
      scope: :attributes

    let(:type){ "node-types"}
  end

  shared_context "for a persisted node-type" do
    parameter :id, 
      "The id of the node-type",
      required: true

    let(:persisted_node_type){ FactoryGirl.create :node_type  }
    let(:id){ persisted_node_type.id.to_s }
    let(:node_type_id){ persisted_node_type.id.to_s }
  end

  post "/node-types" do
    include_context "node-type parameters"

    let(:name){ "Node Type Name"}
    
    example_request "Create a node type" do
      expect(status).to eq 201
      node_type = JSON.parse(response_body)
      expect(node_type["data"]["attributes"]["name"]).to eq name
    end
  end

  patch "/node-types/:node_type_id" do
    include_context "node-type parameters"
    include_context "for a persisted node-type"

    let(:name){ "Updated Node Type Name"}
    
    example_request "Update a node-type" do
      expect(status).to eq 200
      node_type = JSON.parse(response_body)
      expect(node_type["data"]["attributes"]["name"]).to eq name
    end
  end

  get "/node-types" do
    before do
      FactoryGirl.create :node_type, name: "1st node type"
      FactoryGirl.create :node_type, name: "2nd node type"
    end

    example_request "List all node-types" do
      expect(status).to eq 200
      node_types = JSON.parse(response_body)
      expect(node_types["data"].size).to eq 2
    end
  end

  delete "/node-types/:node_type_id" do
    include_context "node-type parameters"
    include_context "for a persisted node-type"
    example_request "Delete a node-type" do
      expect(status).to eq 204
    end
  end

end
