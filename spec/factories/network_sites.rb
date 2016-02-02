FactoryGirl.define do
  factory :network_site do
  	sequence(:name)  { |n| "Site #{n}" }
		address "MyString"
    lat {39.290139}
    lng {-76.614766}
		company
  end

end
