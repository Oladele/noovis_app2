# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Company, type: :model do
	describe "attributes" do
  	it { is_expected.to have_attribute :name }
	end

	describe "associations" do
    let(:company) { FactoryGirl.create(:company) }

	  it "should have many network_sites" do
	  	network_site = subject.network_sites.build(name: "site1")
	  	expect(subject.network_sites).to eq [network_site]
	  end

	  it "should delete associated network_sites on delete" do
      company.network_sites.create(name: "site1")
      expect {company.destroy}.to change {NetworkSite.count}
    end

	  it "should delete associated users on delete" do
      company.users.create(email: "test@example.com", password: "password", password_confirmation: "password", role: :admin)
      expect {company.destroy}.to change {User.count}
    end
	end
  
  describe "validations" do
	  it "validates presence of name" do
	    subject.name = nil
	    subject.valid?
	    expect(subject.errors[:name]).to include "can't be blank"
	  end

  	it { is_expected.to validate_uniqueness_of :name }
	  it "validates the uniqueness of name" do
	    original = FactoryGirl.create(:company)
	    duplicate = FactoryGirl.build(:company, name: original.name)
	    duplicate.valid?
	    expect(duplicate.errors[:name]).to include "has already been taken"
	  end
	end

end
