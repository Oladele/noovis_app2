# == Schema Information
#
# Table name: network_sites
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address    :string
#  company_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lat        :decimal(10, 6)
#  lng        :decimal(10, 6)
#

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

  describe "stats" do
    it "chart_distribution_ports_buildings" do
      network_site = FactoryGirl.create(:network_site_with_buildings)
      building_1_name = network_site.buildings.first.name
      building_2_name = network_site.buildings.last.name

      network_graph_2 = network_site.buildings.last.sheets.first.network_graphs.first
      network_graph_2.update_attribute(:graph, {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            rdts: [
              {
                value: '1',
                cable_run_id: 1,
                ont_sns: [
                  {
                    value: 'ont_sn1',
                    cable_run_id: 1
                  },
                  {
                    value: 'ont_sn2',
                    cable_run_id: 2
                  },
                ]
              }
            ]
          }
        ]
      })

      result = [
        { label: "Active Distribution Ports", group: building_1_name, value: 1 },
        { label: "Spare Distribution Ports", group: building_1_name, value: 11 },
        { label: "Active Distribution Ports", group: building_2_name, value: 2 },
        { label: "Spare Distribution Ports", group: building_2_name, value: 10 }
      ]

      assert_equal result, network_site.chart_distribution_ports_buildings
    end

    it "chart_distribution_ports_sites" do
      result = { "Active Distribution Ports" => 2, "Spare Distribution Ports" => 22 }

      network_site = FactoryGirl.create(:network_site_with_buildings)

      assert_equal result, network_site.chart_distribution_ports_sites
    end

    it "chart_feeder_capacity_buildings" do
      network_site = FactoryGirl.create(:network_site_with_buildings)
      building_1_name = network_site.buildings.first.name
      building_2_name = network_site.buildings.last.name

      network_graph_2 = network_site.buildings.last.sheets.first.network_graphs.first
      network_graph_2.update_attribute(:graph, {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            rdts: [
              value: '1',
              cable_run_id: 1,
              splitters: [
                {
                  value: '1',
                  cable_run_id: 1,
                  ont_sns: [
                    {
                      value: 'ont_sn1',
                      cable_run_id: 1
                    },
                  ]
                },
                {
                  value: '2',
                  cable_run_id: 2,
                  ont_sns: [
                    {
                      value: 'ont_sn2',
                      cable_run_id: 2
                    },
                  ]
                }
              ]
            ]
          }
        ]
      })

      result = [
        { label: "Active PON Ports", group: building_1_name, value: 1 },
        { label: "Spare Feeder Fibers", group: building_1_name, value: 11 },
        { label: "Active PON Ports", group: building_2_name, value: 2 },
        { label: "Spare Feeder Fibers", group: building_2_name, value: 10 }
      ]

      assert_equal result, network_site.chart_feeder_capacity_buildings
    end

    it "chart_feeder_capacity_sites" do
      result = { "Active PON Ports" => 2, "Spare Feeder Fibers" => 22 }

      network_site = FactoryGirl.create(:network_site_with_buildings)

      assert_equal result, network_site.chart_feeder_capacity_sites
    end
  end
end
