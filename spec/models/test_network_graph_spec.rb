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
        { id: 1, created_at: 'x', label: 'BUILDING: building1', network_graph_id: 55, node_level: 1, node_type: 'building', parent_id: 'some_id', updated_at: 'x' },
        { id: 2, created_at: 'x', label: 'OLT: olt1', network_graph_id: 55, node_level: 2, node_type: 'olt', parent_id: 'some_id', updated_at: 'x' },
        { id: 3, created_at: 'x', label: 'BUILDING: building2', network_graph_id: 55, node_level: 1, node_type: 'building', parent_id: 'some_id', updated_at: 'x' }
      ]

      data = TestNetworkGraph.nodes(graph)

      assert_equal result, data
    end
  end
end
