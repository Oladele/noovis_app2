# == Schema Information
#
# Table name: cable_runs
#
#  id              :integer          not null, primary key
#  site            :string
#  building        :string
#  room            :string
#  drop            :string
#  rdt             :string
#  rdt_port        :string
#  fdh_port        :string
#  splitter        :string
#  splitter_fiber  :string
#  sheet_id        :integer
#  pon_card        :string
#  pon_port        :string
#  fdh             :string
#  notes           :text
#  olt_rack        :string
#  olt_chassis     :string
#  vam_shelf       :string
#  vam_module      :string
#  vam_port        :string
#  backbone_shelf  :string
#  backbone_cable  :string
#  backbone_port   :string
#  fdh_location    :string
#  rdt_location    :string
#  ont_model       :string
#  ont_sn          :string
#  rdt_port_count  :string
#  ont_ge_1_device :string
#  ont_ge_1_mac    :string
#  ont_ge_2_device :string
#  ont_ge_2_mac    :string
#  ont_ge_3_device :string
#  ont_ge_3_mac    :string
#  ont_ge_4_device :string
#  ont_ge_4_mac    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :cable_run do
    site "MyString"
    building "MyString"
    room "MyString"
    drop "MyString"
    rdt "MyString"
    rdt_port "MyString"
    fdh_port "MyString"
    splitter "MyString"
    splitter_fiber "MyString"
    sheet
    pon_card "MyString"
    pon_port "MyString"
    fdh "MyString"
    notes "MyText"
    olt_rack "MyString"
    olt_chassis "MyString"
    vam_shelf "MyString"
    vam_module "MyString"
    vam_port "MyString"
    backbone_shelf "MyString"
    backbone_cable "MyString"
    backbone_port "MyString"
    fdh_location "MyString"
    rdt_location "MyString"
    ont_model "MyString"
    ont_sn "MyString"
    rdt_port_count "MyString"
    ont_ge_1_device "MyString"
    ont_ge_1_mac "MyString"
    ont_ge_2_device "MyString"
    ont_ge_2_mac "MyString"
    ont_ge_3_device "MyString"
    ont_ge_3_mac "MyString"
    ont_ge_4_device "MyString"
    ont_ge_4_mac "MyString"
  end

end
