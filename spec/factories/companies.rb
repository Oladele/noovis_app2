# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
	
	factory :company do
  	sequence(:name)  { |n| "Company #{n}" }
	end

end
