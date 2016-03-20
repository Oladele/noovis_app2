require "acceptance_helper"

RSpec.resource "Nodes" do
  header "Content-Type", "application/vnd.api+json"

  shared_context "node parameters" do
    parameter :type,
      "Should always be set to <code>nodes</code>",
      required: true
    parameter :"network-graph",
      "Network Graph id", 
      required: true, scope: :relationships
    parameter :"node-type",
      "Node Type", 
      required: true, scope: :attributes
    parameter :"node-value",
      "Node Value", 
      scope: :attributes
    parameter :"node-level",
      "Node Level",
      scope: :attributes


    let(:type){ "nodes"}
    let(:network_graph_id){ (FactoryGirl.create(:network_graph)).id }
    let(:"network-graph"){{"data"=>{"type"=>"network-graphs", "id"=> network_graph_id}}}
    let(:"node-type"){ "some_node_type" }
  end

  shared_context "for a persisted node" do
    parameter :id, 
      "The id of the node",
      required: true

    let(:persisted_node){ FactoryGirl.create :node  }
    let(:id){ persisted_node.id.to_s }
    let(:node_id){ persisted_node.id.to_s }
  end

  post "/nodes" do
    include_context "node parameters"

    
    example_request "Create a node type" do
      expect(status).to eq 201
    end
  end

  patch "/nodes/:node_id" do
    include_context "node parameters"
    include_context "for a persisted node"

    
    example_request "Update a node" do
      expect(status).to eq 200
    end
  end

  get "/nodes" do
    before do
      FactoryGirl.create :node
      FactoryGirl.create :node
    end

    example_request "List all nodes" do
      expect(status).to eq 200
      nodes = JSON.parse(response_body)
      expect(nodes["data"].size).to eq 2
    end
  end

  delete "/nodes/:node_id" do
    include_context "node parameters"
    include_context "for a persisted node"
    example_request "Delete a node" do
      expect(status).to eq 204
    end
  end

end
