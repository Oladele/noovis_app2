require 'rails_helper'

RSpec.describe CableRun, type: :model do
  describe "attributes" do
    it { is_expected.to have_attribute :sheet_id }
  end

  describe "associations" do
    it "should belong to a sheet" do
      sheet = FactoryGirl.create(:sheet)
      cable_run = sheet.cable_runs.build()
      expect(cable_run.sheet).to eq sheet
    end
  end
end
