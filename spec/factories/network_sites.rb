# == Schema Information
#
# Table name: network_sites
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address    :string
#  company_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lat        :decimal(10, 6)
#  lng        :decimal(10, 6)
#

FactoryGirl.define do
  factory :network_site do
  	sequence(:name)  { |n| "Site #{n}" }
		address "MyString"
    lat {39.290139}
    lng {-76.614766}
		company
  end

end
