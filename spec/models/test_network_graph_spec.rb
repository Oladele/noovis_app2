require 'rails_helper'

RSpec.describe TestNetworkGraph, type: :model do
  describe "stuff" do
    it "nodes" do
      graph = {
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

      result = [
        { id: 1, created_at: 'x', label: 'BUILDING: building1', network_graph_id: 55, node_level: 1, node_type: 'building', parent_id: nil, updated_at: 'x' },
        { id: 2, created_at: 'x', label: 'OLT: olt1', network_graph_id: 55, node_level: 2, node_type: 'olt', parent_id: 1, updated_at: 'x' },
        { id: 3, created_at: 'x', label: 'BUILDING: building2', network_graph_id: 55, node_level: 1, node_type: 'building', parent_id: nil, updated_at: 'x' }
      ]

      data = TestNetworkGraph.nodes(graph)

      assert_equal [nil, 1, nil], data.collect { |r| r[:parent_id] }
      assert_equal [1, 2, 1], data.collect { |r| r[:node_level] }
      assert_equal ['BUILDING: building1', 'OLT: olt1', 'BUILDING: building2'], data.collect { |r| r[:label] }
      assert_equal [1, 2, 3], data.collect { |r| r[:id] }

      assert_equal result, data
    end
  end
end
