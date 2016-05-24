require 'rails_helper'

RSpec.describe TestNetworkGraph, type: :model do
  describe "making nodes and edges" do
    before do
      @test_network_graph = FactoryGirl.create(:test_network_graph)
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

    it "makes nodes and edges" do
      nodes = [
        { id: 1, created_at: @test_network_graph.created_at, label: 'BUILDING: building1', cable_run_id: 22, network_graph_id: 55, node_level: 1, node_type: 'building', node_value: 'building1', parent_id: nil, updated_at: @test_network_graph.updated_at },
        { id: 2, created_at: @test_network_graph.created_at, label: 'OLT: olt1', cable_run_id: 22, network_graph_id: 55, node_level: 2, node_type: 'olt', node_value: 'olt1', parent_id: 1, updated_at: @test_network_graph.updated_at },
        { id: 3, created_at: @test_network_graph.created_at, label: 'BUILDING: building2', cable_run_id: 22, network_graph_id: 55, node_level: 1, node_type: 'building', node_value: 'building2', parent_id: nil, updated_at: @test_network_graph.updated_at }
      ]

      edges = [
        { id: 1, network_graph_id: 55, to_node_id: 2, from_node_id: 1, edge_level: 1, created_at: @test_network_graph.created_at, updated_at: @test_network_graph.updated_at }    # building1 -> olt1
        # building2 has no edge
      ]

      result = @test_network_graph.nodes_and_edges

      # Nodes
      data = result[:nodes]

      assert_equal [1, 2, 3], data.collect { |r| r[:id] }
      assert_equal ['BUILDING: building1', 'OLT: olt1', 'BUILDING: building2'], data.collect { |r| r[:label] }
      assert_equal [1, 2, 1], data.collect { |r| r[:node_level] }
      assert_equal ['building', 'olt', 'building'], data.collect { |r| r[:node_type] }
      assert_equal ['building1', 'olt1', 'building2'], data.collect { |r| r[:node_value] }
      assert_equal [nil, 1, nil], data.collect { |r| r[:parent_id] }

      # TODO: are these useful?
      assert_equal [22, 22, 22], data.collect { |r| r[:cable_run_id] }
      assert_equal [55, 55, 55], data.collect { |r| r[:network_graph_id] }
      assert_equal 3.times.collect { |x| @test_network_graph.created_at }, data.collect { |r| r[:created_at] }
      assert_equal 3.times.collect { |x| @test_network_graph.updated_at }, data.collect { |r| r[:updated_at] }

      assert_equal nodes, data

      # Edges
      data = result[:edges]

      assert_equal [1], data.collect { |r| r[:id] }
      assert_equal [2], data.collect { |r| r[:to_node_id] }
      assert_equal [1], data.collect { |r| r[:from_node_id] }
      assert_equal [1], data.collect { |r| r[:edge_level] }

      # TODO: are these useful?
      assert_equal [55], data.collect { |r| r[:network_graph_id] }
      assert_equal 1.times.collect { |x| @test_network_graph.created_at }, data.collect { |r| r[:created_at] }
      assert_equal 1.times.collect { |x| @test_network_graph.updated_at }, data.collect { |r| r[:updated_at] }

      assert_equal edges, data
    end

    it "port nodes are on the same level as the ont_sn" do
      @test_network_graph.graph = {
        sites: [
          {
            value: 'site1',
            ont_sns: [
              {
                value: 'N/A',
                ont_ge_1_macs: [
                  {
                    value: 'N/A',
                    ont_ge_2_macs: [
                      {
                        value: 'N/A',
                        ont_ge_3_macs: []
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }

      nodes = [
        { id: 1, label: 'ONT_SN: N/A', cable_run_id: 22, network_graph_id: 55, node_level: 1, node_type: 'ont_sn', node_value: 'N/A', parent_id: nil, created_at: @test_network_graph.created_at, updated_at: @test_network_graph.updated_at },
        { id: 2, label: 'ONT_GE_1_MAC: N/A', cable_run_id: 22, network_graph_id: 55, node_level: 2, node_type: 'ont_ge_1_mac', node_value: 'N/A', parent_id: 1, created_at: @test_network_graph.created_at, updated_at: @test_network_graph.updated_at },
        { id: 3, label: 'ONT_GE_2_MAC: N/A', cable_run_id: 22, network_graph_id: 55, node_level: 2, node_type: 'ont_ge_2_mac', node_value: 'N/A', parent_id: 1, created_at: @test_network_graph.created_at, updated_at: @test_network_graph.updated_at }
      ]

      edges = [
        { id: 1, network_graph_id: 55, to_node_id: 2, from_node_id: 1, edge_level: 1, created_at: @test_network_graph.created_at, updated_at: @test_network_graph.updated_at },    # ont_sn -> port 1
        { id: 2, network_graph_id: 55, to_node_id: 3, from_node_id: 1, edge_level: 1, created_at: @test_network_graph.created_at, updated_at: @test_network_graph.updated_at },    # ont_sn -> port 2
      ]

      result = @test_network_graph.nodes_and_edges

      # Nodes
      data = result[:nodes]

      assert_equal [1, 2, 3], data.collect { |r| r[:id] }
      assert_equal ['ONT_SN: N/A', 'ONT_GE_1_MAC: N/A', 'ONT_GE_2_MAC: N/A'], data.collect { |r| r[:label] }
      assert_equal [1, 2, 2], data.collect { |r| r[:node_level] }
      assert_equal ['ont_sn', 'ont_ge_1_mac', 'ont_ge_2_mac'], data.collect { |r| r[:node_type] }
      assert_equal ['N/A', 'N/A', 'N/A'], data.collect { |r| r[:node_value] }
      assert_equal [nil, 1, 1], data.collect { |r| r[:parent_id] }

      assert_equal [22, 22, 22], data.collect { |r| r[:cable_run_id] }
      assert_equal [55, 55, 55], data.collect { |r| r[:network_graph_id] }
      assert_equal 3.times.collect { |x| @test_network_graph.created_at }, data.collect { |r| r[:created_at] }
      assert_equal 3.times.collect { |x| @test_network_graph.updated_at }, data.collect { |r| r[:updated_at] }

      assert_equal nodes, data

      # Edges
      data = result[:edges]

      assert_equal [1, 2], data.collect { |r| r[:id] }
      assert_equal [2, 3], data.collect { |r| r[:to_node_id] }
      assert_equal [1, 1], data.collect { |r| r[:from_node_id] }
      assert_equal [1, 1], data.collect { |r| r[:edge_level] }

      # TODO: are these useful?
      assert_equal [55, 55], data.collect { |r| r[:network_graph_id] }
      assert_equal 2.times.collect { |x| @test_network_graph.created_at }, data.collect { |r| r[:created_at] }
      assert_equal 2.times.collect { |x| @test_network_graph.updated_at }, data.collect { |r| r[:updated_at] }

      assert_equal edges, data
    end
  end
end
