require 'rails_helper'

RSpec.describe Building, type: :model do
  describe "attributes" do
  	it { is_expected.to have_attribute :name }
  	it { is_expected.to have_attribute :network_site_id }
  	it { is_expected.to have_attribute :lat }
  	it { is_expected.to have_attribute :lng }
	end

	describe "associations" do
	  it "should belong to a network site" do
      network_site = FactoryGirl.create(:network_site)
      building = network_site.buildings.build(name: "Lorem ipsum")
      expect(building.network_site).to eq network_site
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

	  it "validates the uniqueness of name scoped to network_site_id" do
	    original = FactoryGirl.create(:building)
	    duplicate = FactoryGirl.build(:building, network_site: original.network_site, name: original.name)
	    duplicate.valid?
	    expect(duplicate.errors[:name]).to include "has already been taken"
	  end
  end
end
