FactoryGirl.define do
  factory :network_template do
    name "MyString"
    description "MyString"
    hierarchy %w(olt_chassis pon_card building fdh splitter rdt room ont_sn ont_ge_mac)
  end
end
