require 'rails_helper'

RSpec.describe Sheet, type: :model do
  describe "attributes" do
    it { is_expected.to have_attribute :name }
    it { is_expected.to have_attribute :workbook_id }
    it { is_expected.to have_attribute :building_id }
  end

  describe "associations" do
    it "should belong to a building" do
      building = FactoryGirl.create(:building)
      sheet = building.sheets.build(name: "Lorem ipsum")
      expect(sheet.building).to eq building
    end

    it "should belong to a workbook" do
      workbook = FactoryGirl.create(:workbook)
      sheet = workbook.sheets.build(name: "Lorem ipsum")
      expect(sheet.workbook).to eq workbook
    end
  end
end
