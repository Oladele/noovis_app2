require 'rails_helper'

RSpec.describe CableRun, type: :model do
  describe "attributes" do
    it { is_expected.to have_attribute :sheet_id }
    it { is_expected.to have_attribute :site }
    it { is_expected.to have_attribute :building }
    it { is_expected.to have_attribute :room }
    it { is_expected.to have_attribute :drop }
    it { is_expected.to have_attribute :rdt }
    it { is_expected.to have_attribute :rdt_port }
    it { is_expected.to have_attribute :fdh_port }
    it { is_expected.to have_attribute :splitter }
    it { is_expected.to have_attribute :splitter_fiber }
    it { is_expected.to have_attribute :pon_card }
    it { is_expected.to have_attribute :pon_port }
    it { is_expected.to have_attribute :fdh }
    it { is_expected.to have_attribute :notes }
    it { is_expected.to have_attribute :olt_rack }
    it { is_expected.to have_attribute :olt_chassis }
    it { is_expected.to have_attribute :vam_shelf }
    it { is_expected.to have_attribute :vam_module }
    it { is_expected.to have_attribute :vam_port }
    it { is_expected.to have_attribute :backbone_shelf }
    it { is_expected.to have_attribute :backbone_cable }
    it { is_expected.to have_attribute :backbone_port }
    it { is_expected.to have_attribute :fdh_location }
    it { is_expected.to have_attribute :rdt_location }
    it { is_expected.to have_attribute :ont_model }
    it { is_expected.to have_attribute :ont_sn }
    it { is_expected.to have_attribute :rdt_port_count }
    it { is_expected.to have_attribute :ont_ge_1_device }
    it { is_expected.to have_attribute :ont_ge_1_mac }
    it { is_expected.to have_attribute :ont_ge_2_device }
    it { is_expected.to have_attribute :ont_ge_2_mac }
    it { is_expected.to have_attribute :ont_ge_3_device }
    it { is_expected.to have_attribute :ont_ge_3_mac }
    it { is_expected.to have_attribute :ont_ge_4_device }
    it { is_expected.to have_attribute :ont_ge_4_mac }
  end

  describe "associations" do
    it "should belong to a sheet" do
      sheet = FactoryGirl.create(:sheet)
      cable_run = sheet.cable_runs.build()
      expect(cable_run.sheet).to eq sheet
    end
  end
end
