# == Schema Information
#
# Table name: node_types
#
#  id         :integer          not null, primary key
#  name       :string
#  picture    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe NodeType, type: :model do
  describe "attributes" do
  	it { is_expected.to have_attribute :name }
  	it { is_expected.to have_attribute :picture }
  end

  describe "validations" do
	  
	  it "validates presence of name" do
	    subject.name = nil
	    subject.valid?
	    expect(subject.errors[:name]).to include "can't be blank"
	  end

	  it "validates the uniqueness of name" do
	    original = FactoryGirl.create(:node_type)
	    duplicate = FactoryGirl.build(:node_type, name: original.name)
	    duplicate.valid?
	    expect(duplicate.errors[:name]).to include "has already been taken"
	  end
	end
end
