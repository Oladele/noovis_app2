# == Schema Information
#
# Table name: sheets
#
#  id          :integer          not null, primary key
#  name        :string
#  workbook_id :integer
#  building_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Sheet, type: :model do
  describe "attributes" do
    it { is_expected.to have_attribute :name }
    it { is_expected.to have_attribute :workbook_id }
    it { is_expected.to have_attribute :building_id }
  end

  describe "associations" do
    let(:sheet) { FactoryGirl.create(:sheet) }

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

	  it "should delete associated cable runs on delete" do
      sheet.cable_runs.create()
      expect {sheet.destroy}.to change {CableRun.count}
    end
  end
  
  describe "validations" do
    it "validates presence of name" do
      subject.name =nil
      subject.valid?
      expect(subject.errors[:name]).to include "can't be blank"
    end

    it "validates presence of workbook_id" do
      subject.workbook_id = nil
      subject.valid?
      expect(subject.errors[:workbook_id]).to include "can't be blank"
    end

    it "validates presence of building_id" do
      subject.building_id = nil
      subject.valid?
      expect(subject.errors[:building_id]).to include "can't be blank"
    end
  end
end
