FactoryGirl.define do
  factory :node_type do
  	sequence(:name)  { |n| "Company #{n}" }
    picture "Picture URL"
  end

end
