# == Schema Information
#
# Table name: edges
#
#  id               :integer          not null, primary key
#  network_graph_id :integer
#  to_node_id       :integer
#  from_node_id     :integer
#  edge_level       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  level            :integer
#  to               :integer
#  from             :integer
#

require 'rails_helper'

RSpec.describe Edge, type: :model do
  describe "attributes" do
  	it { is_expected.to have_attribute :network_graph_id }
  	it { is_expected.to have_attribute :to_node_id }
  	it { is_expected.to have_attribute :from_node_id }
  	it { is_expected.to have_attribute :edge_level }
  	it { is_expected.to have_attribute :level }
  	it { is_expected.to have_attribute :to }
  	it { is_expected.to have_attribute :from }
	end

	describe "associations" do
    it { should belong_to :network_graph }
	end
end
