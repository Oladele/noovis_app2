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

    it "makes nodes and edges check special olt_chassis label and node_type" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            olt_chassis: [
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
                value: 'some_value',
                cable_run_id: 1,
                ont_ge_1_macs: [
                  {
                    value: 'some_value',
                    cable_run_id: 1,
                    ont_ge_2_macs: [
                      {
                        value: 'some_value',
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
        { id: 1, label: 'ONT_SN: some_value', cable_run_id: 1, level: 0, node_type: 'ont_sn', node_value: 'some_value', parent_id: nil },
        { id: 2, label: 'ONT_GE_1_MAC: some_value', cable_run_id: 1, level: 1, node_type: 'ont_ge_1_mac', node_value: 'some_value', parent_id: 1 },
        { id: 3, label: 'ONT_GE_2_MAC: some_value', cable_run_id: 1, level: 1, node_type: 'ont_ge_2_mac', node_value: 'some_value', parent_id: 1 }
      ]

      edges = [
        { id: 1, to: 2, from: 1 },    # ont_sn -> port 1
        { id: 2, to: 3, from: 1 },    # ont_sn -> port 2
      ]

      network_graph = NetworkGraph.create_from_graph(@sheet, graph)

      # Nodes
      data = network_graph.nodes

      assert_equal [1, 2, 3], data.collect { |r| r["id"] }
      assert_equal ['ONT_SN: some_value', 'ONT_GE_1_MAC: some_value', 'ONT_GE_2_MAC: some_value'], data.collect { |r| r["label"] }
      assert_equal %w(1 2 2), data.collect { |r| r["level"] }
      assert_equal ['ont_sn', 'ont_ge_1_mac', 'ont_ge_2_mac'], data.collect { |r| r["node_type"] }
      assert_equal ['some_value', 'some_value', 'some_value'], data.collect { |r| r["node_value"] }
      assert_equal [nil, 1, 1], data.collect { |r| r["parent_id"] }

      assert_equal [1, 1, 1], data.collect { |r| r["cable_run_id"] }

      # Edges
      data = network_graph.edges

      assert_equal [1, 2], data.collect { |r| r["id"] }
      assert_equal [2, 3], data.collect { |r| r["to"] }
      assert_equal [1, 1], data.collect { |r| r["from"] }
    end

    it "node_counts_pretty" do
      result = [
        { node_type: "building", count: 2, node_type_pretty: "Buildings" },
        { node_type: "olt", count: 1, node_type_pretty: "OLTs" },
        { node_type: "wap", count: 0, node_type_pretty: "WAPs" }
      ]

      network_graph = NetworkGraph.create_from_graph(@sheet, @graph)
      assert_equal result, NetworkGraph.node_counts_pretty(network_graph.node_counts)
    end

    it "node_counts_pretty chassis" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            olt_chassis: [
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

      result = [
        { node_type: "olt_chassis", count: 2, node_type_pretty: "OLT Chassis" },
        { node_type: "olt", count: 1, node_type_pretty: "OLTs" },
        { node_type: "wap", count: 0, node_type_pretty: "WAPs" }
      ]

      network_graph = NetworkGraph.create_from_graph(@sheet, graph)
      assert_equal result, NetworkGraph.node_counts_pretty(network_graph.node_counts)
    end

    it "node_counts_pretty with ont_ge_macs" do
      graph = {
        sites: [
          {
            value: 'site1',
            ont_sns: [
              {
                value: 'some_value',
                ont_ge_1_macs: [
                  {
                    value: 'some_value',
                    ont_ge_2_macs: [
                      {
                        value: 'some_value'
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
        { node_type: "ont_sn", count: 1, node_type_pretty: "ONTs" },
        { node_type: "wap", count: 2, node_type_pretty: "WAPs" }
      ]

      network_graph = NetworkGraph.create_from_graph(@sheet, graph)
      assert_equal result, NetworkGraph.node_counts_pretty(network_graph.node_counts)
    end

    it "node_counts_pretty returns empty array with no nodes" do
      assert_equal [], NetworkGraph.node_counts_pretty(NetworkGraph.new.node_counts)
    end

    it "node_count_values" do
      result = {
        "building" => 2,
        "olt" => 1
      }

      network_graph = NetworkGraph.create_from_graph(@sheet, @graph)
      assert_equal result, network_graph.node_counts
    end

    it "don't count N/A or blank values" do
      graph = {
        sites: [
          {
            value: 'site1',
            ont_sns: [
              {
                value: 'some_value',
                ont_ge_1_macs: [
                  {
                    value: 'N/A ',
                    ont_ge_2_macs: [
                      {
                        value: '',
                        ont_ge_3_macs: [
                          { value: 'na' }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }

      result = {
        "ont_sn" => 1,
        "ont_ge_1_mac" => 0,
        "ont_ge_2_mac" => 0,
        "ont_ge_3_mac" => 0
      }

      network_graph = NetworkGraph.create_from_graph(@sheet, graph)
      assert_equal result, network_graph.node_counts
    end

    it "doesn't count empty" do
      assert_equal nil, NetworkGraph.node_counts_for_graphs(nil)
    end

    it "a new olt_chassis value means that all subsequent nodes are counted" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            olt_chassis: [
              {
                value: 'olt_chassis1',
                cable_run_id: 1,
                pon_cards: [
                  {
                    cable_run_id: 1,
                    value: 'pon_card1',
                    pon_ports: [
                      {
                        value: 'pon_port1',
                        cable_run_id: 1
                      }
                    ]
                  }
                ]
              },
            ]
          }
        ]
      }

      network_graph = NetworkGraph.create_from_graph(@sheet, graph)

      graph[:sites].first[:olt_chassis].first[:value] = 'olt_chassis2'

      network_graph2 = NetworkGraph.create_from_graph(@sheet, graph)

      result = {
        "olt_chassis" => 2,
        "pon_card" => 2,
        "pon_port" => 2
      }

      assert_equal result, NetworkGraph.node_counts_for_graphs([network_graph, network_graph2])
    end

    it "counts different nodes correctly 2" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            olt_chassis: [
              {
                value: 'olt_chassis1',
                cable_run_id: 1,
                pon_cards: [
                  {
                    cable_run_id: 1,
                    value: 'pon_card1',
                    pon_ports: [
                      {
                        value: 'pon_port1',
                        cable_run_id: 1
                      }
                    ]
                  }
                ]
              },
            ]
          }
        ]
      }

      network_graph = NetworkGraph.create_from_graph(@sheet, graph)

      graph[:sites].first[:olt_chassis].first[:pon_cards].first[:pon_ports].first[:value] = 'pon_port2'

      network_graph2 = NetworkGraph.create_from_graph(@sheet, graph)

      result = {
        "olt_chassis" => 1,
        "pon_card" => 1,
        "pon_port" => 2
      }

      assert_equal result, NetworkGraph.node_counts_for_graphs([network_graph, network_graph2])
    end

    it "doesn't double count olt_chassis, pon_card, or pon_port with the same value" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            olt_chassis: [
              {
                value: 'olt_chassis1',
                cable_run_id: 1,
                pon_cards: [
                  {
                    cable_run_id: 1,
                    value: 'pon_card1',
                    pon_ports: [
                      {
                        value: 'pon_port1',
                        cable_run_id: 1
                      }
                    ]
                  }
                ]
              },
            ]
          }
        ]
      }

      network_graph = NetworkGraph.create_from_graph(@sheet, graph)
      network_graph2 = NetworkGraph.create_from_graph(@sheet, graph)

      result = {
        "olt_chassis" => 1,
        "pon_card" => 1,
        "pon_port" => 1
      }

      assert_equal result, NetworkGraph.node_counts_for_graphs([network_graph, network_graph2])
    end
  end
end
