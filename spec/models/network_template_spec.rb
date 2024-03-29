# == Schema Information
#
# Table name: network_templates
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  hierarchy   :string           default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe NetworkTemplate, type: :model do
  describe "attributes" do
  	it { is_expected.to have_attribute :name }
  	it { is_expected.to have_attribute :description }
  	it { is_expected.to have_attribute :hierarchy }
  end

  describe "validations" do
	  it "validates presence of name" do
	    subject.name = nil
	    subject.valid?
	    expect(subject.errors[:name]).to include "can't be blank"
	  end
  end
end
