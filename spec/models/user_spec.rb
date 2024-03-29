require 'rails_helper'

RSpec.describe User, type: :model do
	describe "attributes" do
  	it { is_expected.to have_attribute :email }
  	it { is_expected.to have_attribute :company_id }
  	it { is_expected.to have_attribute :role }
	end

	describe "associations" do
    it { is_expected.to belong_to :company }
	end
  
  describe "validations" do
  	it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
	end
end
