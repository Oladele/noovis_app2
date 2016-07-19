# == Schema Information
#
# Table name: workbooks
#
#  id              :integer          not null, primary key
#  name            :string
#  network_site_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :workbook do
  	sequence(:name)  { |n| "Workbook #{n}" }
    network_site
  end

end
