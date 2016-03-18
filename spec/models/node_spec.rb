# == Schema Information
#
# Table name: nodes
#
#  id               :integer          not null, primary key
#  network_graph_id :integer
#  node_value       :string
#  node_level       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_id        :integer
#  cable_run_id     :integer
#  node_type        :string
#  label            :string
#  level            :string
#

require 'rails_helper'

RSpec.describe Node, type: :model do
  describe "attributes" do
  	it { is_expected.to have_attribute :network_graph_id }
  	it { is_expected.to have_attribute :node_type }
  	it { is_expected.to have_attribute :node_value }
  	it { is_expected.to have_attribute :node_level }
	end

	describe "associations" do
	  # it "should belong to a network graph" do
   #    network_graph = FactoryGirl.create(:network_graph)
   #    node = network_graph.nodes.build()
   #    expect(node.network_graph).to eq network_graph
	  # end
	  
	end
  
  describe "validations" do
  	it "validates presence of network_graph_id" do
	    subject.network_graph_id = nil
	    subject.valid?
	    expect(subject.errors[:network_graph_id]).to include "can't be blank"
	  end
	  
	  it "validates presence of node_type" do
	    subject.node_type = nil
	    subject.valid?
	    expect(subject.errors[:node_type]).to include "can't be blank"
	  end
  end
end
