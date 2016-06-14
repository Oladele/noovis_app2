# == Schema Information
#
# Table name: network_graphs
#
#  id                  :integer          not null, primary key
#  sheet_id            :integer
#  network_template_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe NetworkGraph, type: :model do
  describe "making nodes and edges" do
    before do
      @sheet = FactoryGirl.create(:sheet)
      @graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: 'building1',
                cable_run_id: 1,
                olts: [
                  {
                    cable_run_id: 1,
                    value: 'olt1'
                  }
                ]
              },
              {
                cable_run_id: 2,
                value: 'building2'
              }
            ]
          }
        ]
      }
    end

    it "self.create_from_graph" do
      network_graph = NetworkGraph.create_from_graph(@sheet, @graph)

      assert_equal @sheet.id, network_graph.sheet_id
      assert network_graph.graph
      assert network_graph.nodes
      assert network_graph.edges
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

      network_graph = NetworkGraph.create_from_graph(@sheet, @graph)

      # Nodes
      data = network_graph.nodes

      assert_equal [1, 2, 3], data.collect { |r| r["id"] }
      assert_equal ['BUILDING: building1', 'OLT: olt1', 'BUILDING: building2'], data.collect { |r| r["label"] }
      assert_equal %w(1 2 1), data.collect { |r| r["level"] }
      assert_equal ['building', 'olt', 'building'], data.collect { |r| r["node_type"] }
      assert_equal ['building1', 'olt1', 'building2'], data.collect { |r| r["node_value"] }
      assert_equal [nil, 1, nil], data.collect { |r| r["parent_id"] }
      assert_equal [1, 1, 2], data.collect { |r| r["cable_run_id"] }

      # Edges
      data = network_graph.edges

      assert_equal [1], data.collect { |r| r["id"] }
      assert_equal [2], data.collect { |r| r["to"] }
      assert_equal [1], data.collect { |r| r["from"] }
    end

    it "makes nodes and edges 2" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            olt_chasses: [
              {
                value: 'olt_chassis1',
                cable_run_id: 1,
                olts: [
                  {
                    cable_run_id: 1,
                    value: 'olt1'
                  }
                ]
              },
              {
                cable_run_id: 2,
                value: 'olt_chassis2'
              }
            ]
          }
        ]
      }

      nodes = [
        { id: 1, label: 'OLT_CHASSIS: olt_chassis1', cable_run_id: 1, level: 0, node_type: 'olt_chassis', node_value: 'olt_chassis1', parent_id: nil },
        { id: 2, label: 'OLT: olt1', cable_run_id: 1, level: 1, node_type: 'olt', node_value: 'olt1', parent_id: 1 },
        { id: 3, label: 'OLT_CHASSIS: olt_chassis2', cable_run_id: 2, level: 0, node_type: 'olt_chassis', node_value: 'olt_chassis2', parent_id: nil }
      ]

      edges = [
        { id: 1, to: 2, from: 1 }    # building1 -> olt1
        # building2 has no edge
      ]

      network_graph = NetworkGraph.create_from_graph(@sheet, graph)

      # Nodes
      data = network_graph.nodes

      assert_equal [1, 2, 3], data.collect { |r| r["id"] }
      assert_equal ['OLT_CHASSIS: olt_chassis1', 'OLT: olt1', 'OLT_CHASSIS: olt_chassis2'], data.collect { |r| r["label"] }
      assert_equal %w(1 2 1), data.collect { |r| r["level"] }
      assert_equal ['olt_chassis', 'olt', 'olt_chassis'], data.collect { |r| r["node_type"] }
      assert_equal ['olt_chassis1', 'olt1', 'olt_chassis2'], data.collect { |r| r["node_value"] }
      assert_equal [nil, 1, nil], data.collect { |r| r["parent_id"] }
      assert_equal [1, 1, 2], data.collect { |r| r["cable_run_id"] }

      # Edges
      data = network_graph.edges

      assert_equal [1], data.collect { |r| r["id"] }
      assert_equal [2], data.collect { |r| r["to"] }
      assert_equal [1], data.collect { |r| r["from"] }
    end

    it "port nodes are on the same level as the ont_sn" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            ont_sns: [
              {
                value: 'N/A',
                cable_run_id: 1,
                ont_ge_1_macs: [
                  {
                    value: 'N/A',
                    cable_run_id: 1,
                    ont_ge_2_macs: [
                      {
                        value: 'N/A',
                        cable_run_id: 1
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

      network_graph = NetworkGraph.create_from_graph(@sheet, graph)

      # Nodes
      data = network_graph.nodes

      assert_equal [1, 2, 3], data.collect { |r| r["id"] }
      assert_equal ['ONT_SN: N/A', 'ONT_GE_1_MAC: N/A', 'ONT_GE_2_MAC: N/A'], data.collect { |r| r["label"] }
      assert_equal %w(1 2 2), data.collect { |r| r["level"] }
      assert_equal ['ont_sn', 'ont_ge_1_mac', 'ont_ge_2_mac'], data.collect { |r| r["node_type"] }
      assert_equal ['N/A', 'N/A', 'N/A'], data.collect { |r| r["node_value"] }
      assert_equal [nil, 1, 1], data.collect { |r| r["parent_id"] }

      assert_equal [1, 1, 1], data.collect { |r| r["cable_run_id"] }

      # Edges
      data = network_graph.edges

      assert_equal [1, 2], data.collect { |r| r["id"] }
      assert_equal [2, 3], data.collect { |r| r["to"] }
      assert_equal [1, 1], data.collect { |r| r["from"] }
    end

    it "node_counts" do
      result = [
        { node_type: "building", count: 2, node_type_pretty: "Buildings" },
        { node_type: "olt", count: 1, node_type_pretty: "Olts" }
      ]

      network_graph = NetworkGraph.create_from_graph(@sheet, @graph)
      assert_equal result, network_graph.node_counts
    end

    it "node_counts 2" do
      graph = {
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
        { node_type: "ont_sn", count: 1, node_type_pretty: "Ont Sns" },
        { node_type: "ont_ge_1_mac", count: 1, node_type_pretty: "Ont Ge 1 Macs" },
        { node_type: "ont_ge_2_mac", count: 1, node_type_pretty: "Ont Ge 2 Macs" }
      ]

      network_graph = NetworkGraph.create_from_graph(@sheet, graph)
      assert_equal result, network_graph.node_counts
    end

    it "node_count_for_type" do
      network_graph = NetworkGraph.create_from_graph(@sheet, @graph)
      assert_equal 1, network_graph.node_count_for_type("olt")
      assert_equal 0, network_graph.node_count_for_type("blah")
    end
  end
end
