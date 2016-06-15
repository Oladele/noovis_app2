require 'rails_helper'

RSpec.describe NodeStats, type: :model do
  describe "methods" do
	  it "node_counts" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            rdts: [
              {
                value: '1',
                cable_run_id: 1,
                splitters: [
                  value: '1',
                  cable_run_id: 1,
                  ont_sns: [
                    {
                      value: 'ont_sn1',
                      cable_run_id: 1
                    },
                  ]
                ]
              }
            ]
          }
        ]
      }
      network_graph = NetworkGraph.create_from_graph(FactoryGirl.create(:sheet), graph)

			node_types = [
				"olt_chassis",
				"pon_card",
				"fdh",
				"splitter",
				"rdt",
				"ont_sn",
				"room"
			]

      counts = NodeStats.new(network_graph.nodes).node_counts(node_types)
      assert_equal 0, counts.select { |count| count.node_type == "olt_chassis" }.first.count
      assert_equal 0, counts.select { |count| count.node_type == "pon_card" }.first.count
      assert_equal 0, counts.select { |count| count.node_type == "fdh" }.first.count
      assert_equal 1, counts.select { |count| count.node_type == "splitter" }.first.count
      assert_equal 1, counts.select { |count| count.node_type == "rdt" }.first.count
      assert_equal 1, counts.select { |count| count.node_type == "ont_sn" }.first.count
      assert_equal 0, counts.select { |count| count.node_type == "room" }.first.count
	  end
  end
end
