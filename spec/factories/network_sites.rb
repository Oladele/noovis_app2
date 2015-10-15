FactoryGirl.define do
  factory :network_site do
  	sequence(:name)  { |n| "Site #{n}" }
		address "MyString"
		company
  end

end
