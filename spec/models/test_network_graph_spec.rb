require 'rails_helper'

RSpec.describe TestNetworkGraph, type: :model do
  describe "making nodes and edges" do
    before do
      @test_network_graph = FactoryGirl.build(:test_network_graph)
      @test_network_graph.graph = {
        sites: [
          {
            value: 'site1',
            buildings: [
              {
                value: 'building1',
                olts: [
                  {
                    value: 'olt1',
                    somethings: []
                  }
                ]
              },
              {
                value: 'building2',
                olts: []
              }
            ]
          }
        ]
      }
    end

    it "makes nodes" do
      result = [
        { id: 1, created_at: 'x', label: 'BUILDING: building1', cable_run_id: 22, network_graph_id: 55, node_level: 1, node_type: 'building', node_value: 'building1', parent_id: nil, updated_at: 'x' },
        { id: 2, created_at: 'x', label: 'OLT: olt1', cable_run_id: 22, network_graph_id: 55, node_level: 2, node_type: 'olt', node_value: 'olt1', parent_id: 1, updated_at: 'x' },
        { id: 3, created_at: 'x', label: 'BUILDING: building2', cable_run_id: 22, network_graph_id: 55, node_level: 1, node_type: 'building', node_value: 'building2', parent_id: nil, updated_at: 'x' }
      ]

      data = @test_network_graph.nodes

      assert_equal [nil, 1, nil], data.collect { |r| r[:parent_id] }
      assert_equal [1, 2, 1], data.collect { |r| r[:node_level] }
      assert_equal ['BUILDING: building1', 'OLT: olt1', 'BUILDING: building2'], data.collect { |r| r[:label] }
      assert_equal [1, 2, 3], data.collect { |r| r[:id] }

      assert_equal result, data
    end

    it "makes edges" do
      result = [
        { id: 1, network_graph_id: 55, to_node_id: 2, from_node_id: nil, edge_level: 1, created_at: 'x', updated_at: 'x' },
        { id: 2, network_graph_id: 55, to_node_id: nil, from_node_id: 1, edge_level: 2, created_at: 'x', updated_at: 'x' },
        { id: 3, network_graph_id: 55, to_node_id: nil, from_node_id: nil, edge_level: 1, created_at: 'x', updated_at: 'x' }
      ]

      data = @test_network_graph.edges

      assert_equal [1, 2, 3], data.collect { |r| r[:id] }
      assert_equal [2, nil, nil], data.collect { |r| r[:to_node_id] }
      assert_equal [nil, 1, nil], data.collect { |r| r[:from_node_id] }
      assert_equal [1, 2, 1], data.collect { |r| r[:edge_level] }

      assert_equal result, data
    end
  end
end
