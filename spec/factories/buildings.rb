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
  end

end
