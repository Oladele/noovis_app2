require "rails_helper"

RSpec.describe Workbook, type: :model do
  describe "atttributes" do
    it { is_expected.to have_attribute :name }
    it { is_expected.to have_attribute :network_site_id }
  end

  describe "associations" do
    let(:workbook) { FactoryGirl.create(:workbook) }

    it "should belong to a network site" do
      network_site = FactoryGirl.create(:network_site)
      workbook = network_site.workbooks.build(name: "Lorem ipsum")
      expect(workbook.network_site).to eq network_site
    end

    it "should have many sheets" do
	  	sheet = subject.sheets.build(name: "sheet1")
	  	expect(subject.sheets).to eq [sheet]
    end

	  it "should delete associated sheets on delete" do
      workbook.sheets.create(name: "sheet1", building: FactoryGirl.create(:building))
      expect {workbook.destroy}.to change {Sheet.count}
    end
  end

  describe "validations" do
    it "validates presence of network_site_id" do
      subject.network_site_id = nil
      subject.valid?
	    expect(subject.errors[:network_site_id]).to include "can't be blank"
    end

    it "validates presence of name" do
      subject.name = nil
      subject.valid?
	    expect(subject.errors[:name]).to include "can't be blank"
    end
  end
end
