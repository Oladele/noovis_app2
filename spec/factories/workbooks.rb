FactoryGirl.define do
  factory :workbook do
  	sequence(:name)  { |n| "Workbook #{n}" }
    network_site
  end

end
