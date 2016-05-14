# == Schema Information
#
# Table name: buildings
#
#  id              :integer          not null, primary key
#  name            :string
#  lat             :decimal(10, 6)
#  lng             :decimal(10, 6)
#  network_site_id :integer
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :building do
  	sequence(:name)  { |n| "Building #{n}" }
    lat {39.290139}
    lng {-76.614766}
    network_site
    description "MyText"

    factory :building_with_import_job do
      after(:create) do |building, evaluator|
        create_list(:import_job, 1, building: building)
      end
    end

    factory :building_with_expired_import_job do
      after(:create) do |building, evaluator|
        create_list(:expired_import_job, 1, building: building)
      end
    end

    factory :building_with_sheet do
      after(:create) do |building, evaluator|
        create_list(:sheet_with_network_graph, 1, building: building)
      end
    end
  end

end
