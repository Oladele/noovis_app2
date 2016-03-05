require 'rails_helper'

RSpec.describe NetworkSite, type: :model do
  describe "attributes" do
  	it { is_expected.to have_attribute :name }
  	it { is_expected.to have_attribute :company_id }
  	it { is_expected.to have_attribute :lat }
  	it { is_expected.to have_attribute :lng }
  	it { is_expected.to have_attribute :address }
	end

	describe "associations" do
    let(:network_site) { FactoryGirl.create(:network_site) }

	  it "should belong to a company" do
	  	company = FactoryGirl.create(:company)
	  	network_site = company.network_sites.build(name: "Lorem ipsum")
	  	expect(network_site.company).to eq company
	  end

    it "should have many buildings" do
	  	building = subject.buildings.build(name: "building1")
	  	expect(subject.buildings).to eq [building]
    end

	  it "should delete associated building on delete" do
      network_site.buildings.create(name: "building1")
      expect {network_site.destroy}.to change {Building.count}
    end

	  it "should delete associated workbook on delete" do
      network_site.workbooks.create(name: "workbook1")
      expect {network_site.destroy}.to change {Workbook.count}
    end
	end
  
  describe "validations" do
  	it "validates presence of company_id" do
	    subject.company_id = nil
	    subject.valid?
	    expect(subject.errors[:company_id]).to include "can't be blank"
	  end
	  
	  it "validates presence of name" do
	    subject.name = nil
	    subject.valid?
	    expect(subject.errors[:name]).to include "can't be blank"
	  end

	  it "validates the uniqueness of name scoped to company_id" do
	    original = FactoryGirl.create(:network_site)
	    duplicate = FactoryGirl.build(:network_site, company: original.company, name: original.name)
	    duplicate.valid?
	    expect(duplicate.errors[:name]).to include "has already been taken"
	  end
	end
end
