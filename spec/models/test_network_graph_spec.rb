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
                    value: 'olt1'
                  }
                ]
              },
              {
                value: 'building2'
              }
            ]
          }
        ]
      }
    end

    it "makes nodes and edges" do
      nodes = [
        { id: 1, label: 'BUILDING: building1', cable_run_id: 1, level: 0, node_type: 'building', node_value: 'building1', parent_id: nil },
        { id: 2, label: 'OLT: olt1', cable_run_id: 1, level: 1, node_type: 'olt', node_value: 'olt1', parent_id: 1 },
        { id: 3, label: 'BUILDING: building2', cable_run_id: 2, level: 0, node_type: 'building', node_value: 'building2', parent_id: nil }
      ]

      edges = [
        { id: 1, to: 2, from: 1 }    # building1 -> olt1
        # building2 has no edge
      ]

      result = @test_network_graph.nodes_and_edges

      # Nodes
      data = result[:nodes]

      assert_equal [1, 2, 3], data.collect { |r| r[:id] }
      assert_equal ['BUILDING: building1', 'OLT: olt1', 'BUILDING: building2'], data.collect { |r| r[:label] }
      assert_equal %w(1 2 1), data.collect { |r| r[:level] }
      assert_equal ['building', 'olt', 'building'], data.collect { |r| r[:node_type] }
      assert_equal ['building1', 'olt1', 'building2'], data.collect { |r| r[:node_value] }
      assert_equal [nil, 1, nil], data.collect { |r| r[:parent_id] }
      assert_equal [1, 1, 2], data.collect { |r| r[:cable_run_id] }

      # Edges
      data = result[:edges]

      assert_equal [1], data.collect { |r| r[:id] }
      assert_equal [2], data.collect { |r| r[:to] }
      assert_equal [1], data.collect { |r| r[:from] }
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
                        value: 'N/A'
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
        { id: 1, label: 'ONT_SN: N/A', cable_run_id: 1, level: 0, node_type: 'ont_sn', node_value: 'N/A', parent_id: nil },
        { id: 2, label: 'ONT_GE_1_MAC: N/A', cable_run_id: 1, level: 1, node_type: 'ont_ge_1_mac', node_value: 'N/A', parent_id: 1 },
        { id: 3, label: 'ONT_GE_2_MAC: N/A', cable_run_id: 1, level: 1, node_type: 'ont_ge_2_mac', node_value: 'N/A', parent_id: 1 }
      ]

      edges = [
        { id: 1, to: 2, from: 1 },    # ont_sn -> port 1
        { id: 2, to: 3, from: 1 },    # ont_sn -> port 2
      ]

      result = @test_network_graph.nodes_and_edges

      # Nodes
      data = result[:nodes]

      assert_equal [1, 2, 3], data.collect { |r| r[:id] }
      assert_equal ['ONT_SN: N/A', 'ONT_GE_1_MAC: N/A', 'ONT_GE_2_MAC: N/A'], data.collect { |r| r[:label] }
      assert_equal %w(1 2 2), data.collect { |r| r[:level] }
      assert_equal ['ont_sn', 'ont_ge_1_mac', 'ont_ge_2_mac'], data.collect { |r| r[:node_type] }
      assert_equal ['N/A', 'N/A', 'N/A'], data.collect { |r| r[:node_value] }
      assert_equal [nil, 1, 1], data.collect { |r| r[:parent_id] }

      assert_equal [1, 1, 1], data.collect { |r| r[:cable_run_id] }

      # Edges
      data = result[:edges]

      assert_equal [1, 2], data.collect { |r| r[:id] }
      assert_equal [2, 3], data.collect { |r| r[:to] }
      assert_equal [1, 1], data.collect { |r| r[:from] }
    end

    it "node_counts" do
      # "node-counts":[{"node_type":"olt_chassis","count":0,"node_type_pretty":"Olt chasses"},{"node_type":"pon_card","count":2,"node_type_pretty":"Pon cards"},{"node_type":"fdh","count":2,"node_type_pretty":"Fdhs"},{"node_type":"splitter","count":2,"node_type_pretty":"Splitters"},

      result = [
        { node_type: "building", count: 2, node_type_pretty: "Building" },
        { node_type: "olt", count: 1, node_type_pretty: "Olt" }
      ]

      assert_equal result, @test_network_graph.node_counts
    end

    it "node_counts 2" do
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
                        value: 'N/A'
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }

      result = [
        { node_type: "ont_sn", count: 1, node_type_pretty: "Ont_sn" },
        { node_type: "ont_ge_1_mac", count: 1, node_type_pretty: "Ont_ge_1_mac" },
        { node_type: "ont_ge_2_mac", count: 1, node_type_pretty: "Ont_ge_2_mac" }
      ]

      assert_equal result, @test_network_graph.node_counts
    end
  end
end
