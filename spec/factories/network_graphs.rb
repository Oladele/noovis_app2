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

FactoryGirl.define do
  factory :network_graph do
    sheet
    network_template
    nodes {
      [
        { id: 1, label: 'BUILDING: building1', cable_run_id: 1, level: 0, node_type: 'building', node_value: 'building1', parent_id: nil },
        { id: 2, label: 'OLT: olt1', cable_run_id: 1, level: 1, node_type: 'olt', node_value: 'olt1', parent_id: 1 },
        { id: 3, label: 'BUILDING: building2', cable_run_id: 2, level: 0, node_type: 'building', node_value: 'building2', parent_id: nil }
      ]
    }
    edges { [{ id: 1, to: 2, from: 1 }] }
    node_counts {
      { sites: 1, rdts: 1, splitters: 1, ont_sns: 1 }
    }
    graph {
      {
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
   }
  end

end
