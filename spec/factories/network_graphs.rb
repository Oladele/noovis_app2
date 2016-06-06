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
    graph {
      {
      sites: [
        {
          value: 'site1',
          cable_run_id: 1,
          buildings: [
            {
              value: 'building1',
              cable_run_id: 1
            },
          ]
        }
      ]
    }
 }
  end

end
