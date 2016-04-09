require 'rails_helper'

RSpec.describe Company, type: :model do
	describe "attributes" do
  	it { is_expected.to have_attribute :id }
	end
end
