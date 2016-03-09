FactoryGirl.define do
  factory :sheet do
  	sequence(:name)  { |n| "Sheet #{n}" }
    workbook
    building
  end

end
