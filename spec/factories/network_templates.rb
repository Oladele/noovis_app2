# == Schema Information
#
# Table name: network_templates
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  hierarchy   :string           default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :network_template do
    name "MyString"
    description "MyString"
    hierarchy %w(olt_chassis pon_card building fdh splitter rdt room ont_sn ont_ge_mac)
  end
end
