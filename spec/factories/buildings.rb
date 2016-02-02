FactoryGirl.define do
  factory :building do
  	sequence(:name)  { |n| "Building #{n}" }
    lat {39.290139}
    lng {-76.614766}
    network_site
    description "MyText"
  end

end
