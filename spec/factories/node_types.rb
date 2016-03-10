# == Schema Information
#
# Table name: node_types
#
#  id         :integer          not null, primary key
#  name       :string
#  picture    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :node_type do
  	sequence(:name)  { |n| "Company #{n}" }
    picture "Picture URL"
  end

end
