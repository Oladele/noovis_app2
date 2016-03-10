# == Schema Information
#
# Table name: nodes
#
#  id               :integer          not null, primary key
#  network_graph_id :integer
#  node_type_id     :integer
#  node_value       :string
#  x_pos            :decimal(8, 2)
#  y_pos            :decimal(8, 2)
#  node_level       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Node, type: :model do
  describe "attributes" do
  	it { is_expected.to have_attribute :network_graph_id }
  	it { is_expected.to have_attribute :node_type_id }
  	it { is_expected.to have_attribute :node_value }
  	it { is_expected.to have_attribute :node_level }
  	it { is_expected.to have_attribute :x_pos }
  	it { is_expected.to have_attribute :y_pos }
	end

	describe "associations" do
	  it "should belong to a network graph" do
      network_graph = FactoryGirl.create(:network_graph)
      node = network_graph.nodes.build()
      expect(node.network_graph).to eq network_graph
	  end
	  
	  it "should belong to a node type" do
      node_type = FactoryGirl.create(:node_type)
      node = node_type.nodes.build()
      expect(node.node_type).to eq node_type
	  end
	end
  
  describe "validations" do
  	it "validates presence of network_graph_id" do
	    subject.network_graph_id = nil
	    subject.valid?
	    expect(subject.errors[:network_graph_id]).to include "can't be blank"
	  end
	  
	  it "validates presence of node_type_id" do
	    subject.node_type_id = nil
	    subject.valid?
	    expect(subject.errors[:node_type_id]).to include "can't be blank"
	  end
  end
end
