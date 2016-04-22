#require "acceptance_helper"
#
#RSpec.resource "NetworkGraphs" do
#  header "Content-Type", "application/vnd.api+json"
#
#  shared_context "network-graph parameters" do
#    parameter :type,
#      "Should always be set to <code>network-graphs</code>",
#      required: true
#    parameter :sheet, 
#      "Sheet id", 
#      required: true, scope: :relationships
#    parameter :"network-template", 
#      "Network Template id", 
#      required: true, scope: :relationships
#
#    let(:type){ "network-graphs"}
#    let(:sheet_id){ (FactoryGirl.create(:sheet)).id }
#    let(:sheet){{"data"=>{"type"=>"sheets", "id"=> sheet_id}}}
#    let(:network_template_id){ (FactoryGirl.create(:network_template)).id }
#    let(:"network-template"){{"data"=>{"type"=>"network-templates", "id"=> network_template_id}}}
#  end
#
#  shared_context "for a persisted network-graph" do
#    parameter :id, 
#      "The id of the network-graph",
#      required: true
#
#    let(:persisted_network_graph){ FactoryGirl.create :network_graph  }
#    let(:id){ persisted_network_graph.id.to_s }
#    let(:network_graph_id){ persisted_network_graph.id.to_s }
#  end
#
#  post "/network-graphs" do
#    include_context "network-graph parameters"
#
#    example_request "Create a network graph" do
#      expect(status).to eq 201
#    end
#  end
#
#  patch "/network-graphs/:network_graph_id" do
#    include_context "network-graph parameters"
#    include_context "for a persisted network-graph"
#
#    let(:network_template_id){ (FactoryGirl.create(:network_template)).id }
#    
#    example_request "Update a network-graph" do
#      expect(status).to eq 200
#    end
#  end
#
#  get "/network-graphs" do
#    before do
#      FactoryGirl.create :network_graph
#      FactoryGirl.create :network_graph
#    end
#
#    example_request "List all network-graphs" do
#      expect(status).to eq 200
#      network_graphs = JSON.parse(response_body)
#      expect(network_graphs["data"].size).to eq 2
#    end
#  end
#
#  delete "/network-graphs/:network_graph_id" do
#    include_context "network-graph parameters"
#    include_context "for a persisted network-graph"
#    example_request "Delete a network-graph" do
#      expect(status).to eq 204
#    end
#  end
#
#end
