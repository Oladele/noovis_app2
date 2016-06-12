# == Schema Information
#
# Table name: sheets
#
#  id          :integer          not null, primary key
#  name        :string
#  workbook_id :integer
#  building_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :sheet do
  	sequence(:name)  { |n| "Sheet #{n}" }
    workbook
    building

    factory :sheet_with_cable_runs do
      after(:create) do |sheet, evaluator|
        create_list(:cable_run, 2, sheet: sheet)
      end
    end

    factory :sheet_with_network_graph do
      after(:create) do |sheet, evaluator|
        NetworkGraph.create_from_graph(sheet, {
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
        }.with_indifferent_access)
      end
    end
  end

end
