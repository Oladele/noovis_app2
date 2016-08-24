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
    describe "distribution_ports" do
      before do
        @network_site = FactoryGirl.create(:network_site_with_buildings)
        @building_1_name = @network_site.buildings.first.name
        @building_2_name = @network_site.buildings.last.name

        sheet = @network_site.buildings.last.sheets.first
        NetworkGraph.create_from_graph(sheet, {
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
        }.with_indifferent_access)
      end

      it "chart_distribution_ports_buildings" do
        result = [
          { label: "Active Distribution Ports", group: @building_1_name, value: 1 },
          { label: "Spare Distribution Ports", group: @building_1_name, value: 11 },
          { label: "Active Distribution Ports", group: @building_2_name, value: 2 },
          { label: "Spare Distribution Ports", group: @building_2_name, value: 10 }
        ]

        assert_equal result.sort_by { |hash| hash[:group] }, @network_site.chart_distribution_ports_buildings
      end

      it "chart_distribution_ports_sites" do
        result = { "Active Distribution Ports" => 3, "Spare Distribution Ports" => 21 }

        assert_equal result, @network_site.chart_distribution_ports_site
      end
    end

    describe "feeder_capacity" do
      before do
        @network_site = FactoryGirl.create(:network_site_with_buildings)
        @building_1_name = @network_site.buildings.first.name
        @building_2_name = @network_site.buildings.last.name

        sheet = @network_site.buildings.last.sheets.first
        NetworkGraph.create_from_graph(sheet, {
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
        }.with_indifferent_access)
      end

      it "chart_feeder_capacity_buildings" do
        result = [
          { label: "Active PON Ports", group: @building_1_name, value: 1 },
          { label: "Spare Feeder Fibers", group: @building_1_name, value: 11 },
          { label: "Active PON Ports", group: @building_2_name, value: 2 },
          { label: "Spare Feeder Fibers", group: @building_2_name, value: 10 }
        ]

        assert_equal result.sort_by { |hash| hash[:group] }, @network_site.chart_feeder_capacity_buildings
      end

      it "chart_feeder_capacity_sites" do
        result = { "Active PON Ports" => 3, "Spare Feeder Fibers" => 21 }
        assert_equal result, @network_site.chart_feeder_capacity_site
      end
    end

    describe "pon_usage" do
      before do
        @network_site = FactoryGirl.create(:network_site_with_buildings)
        @building_1_name = @network_site.buildings.first.name
        @building_2_name = @network_site.buildings.last.name

        sheet = @network_site.buildings.last.sheets.first
        NetworkGraph.create_from_graph(sheet, {
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
        }.with_indifferent_access)
      end

      it "chart_pon_usage_buildings" do
        result = [
          { label: "Active Channels", group: @building_1_name, value: 1 },
          { label: "Standby Channels", group: @building_1_name, value: 31 },
          { label: "Active Channels", group: @building_2_name, value: 2 },
          { label: "Standby Channels", group: @building_2_name, value: 62 }
        ]

        assert_equal result.sort_by { |hash| hash[:group] }, @network_site.chart_pon_usage_buildings
      end

      it "chart_pon_usage_sites" do
        result = { "Active Channels" => 3, "Standby Channels" => 93 }

        assert_equal result, @network_site.chart_pon_usage_site
      end
    end

    it "network_element_counts with no graphs" do
      network_site = FactoryGirl.build(:network_site)
      assert_equal [], network_site.network_element_counts
    end

    it "network_element_counts" do
      network_site = FactoryGirl.create(:network_site_with_buildings)
      building_1_name = network_site.buildings.first.name
      building_2_name = network_site.buildings.last.name

      sheet = network_site.buildings.last.sheets.first
      sheet.network_graphs.destroy_all
      NetworkGraph.create_from_graph(sheet, {
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
                      cable_run_id: 1,
                      ont_ge_1_macs: [
                        {
                          value: 'ont_ge_1_mac_1',
                          cable_run_id: 1,
                          ont_ge_2_macs: [{ value: 'ont_ge_2_mac_1', cable_run_id: 1 }]
                        }
                      ]
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
      }.with_indifferent_access)

      result = [
        {
          "BLDG" => network_site.name,
          "Bldgs" => 2,
          "OLTs" => 0,
          "PON Cards" => 0,
          "FDHs" => 0,
          "Splitters" => 3,
          "RDTs" => 2,
          "ONTs" => 3,
          "WAPs" => 3,
          "Rooms" => 0,
          "Active Channels" => 3,
          "Standby Channels" => (3*32) - 3,
          "Active PON Ports" => 3,
          "Spare Feeder Fibers" => 12*2 - 3,
          "Active Distribution Ports" => 3,
          "Spare Distribution Ports" => (2 * 12) - 3,
          "Actual RDT Count" => 2
        },
        {
          "BLDG" => network_site.buildings.first.name,
          "Bldgs" => 1,
          "OLTs" => 0,
          "PON Cards" => 0,
          "FDHs" => 0,
          "Splitters" => 1,
          "RDTs" => 1,
          "ONTs" => 1,
          "WAPs" => 1,
          "Rooms" => 0,
          "Active Channels" => 1,
          "Standby Channels" => (1*32) - 1,
          "Active PON Ports" => 1,
          "Spare Feeder Fibers" => 12 - 1,
          "Active Distribution Ports" => 1,
          "Spare Distribution Ports" => (1 * 12) - 1,
          "Actual RDT Count" => 1
        },
        {
          "BLDG" => network_site.buildings.last.name,
          "Bldgs" => 1,
          "OLTs" => 0,
          "PON Cards" => 0,
          "FDHs" => 0,
          "Splitters" => 2,
          "RDTs" => 1,
          "ONTs" => 2,
          "WAPs" => 2,
          "Rooms" => 0,
          "Active Channels" => 2,
          "Standby Channels" => (2*32) - 2,
          "Active PON Ports" => 2,
          "Spare Feeder Fibers" => 12 - 2,
          "Active Distribution Ports" => 2,
          "Spare Distribution Ports" => (1 * 12) - 2,
          "Actual RDT Count" => 1
        }
      ]

      counts = network_site.network_element_counts

      assert_equal result.first["BLDG"], counts.first["BLDG"]
      assert_equal result.first["Bldgs"], counts.first["Bldgs"]
      assert_equal result.first["OLTs"], counts.first["OLTs"]
      assert_equal result.first["PON Cards"], counts.first["PON Cards"]
      assert_equal result.first["FDHs"], counts.first["FDHs"]
      assert_equal result.first["Splitters"], counts.first["Splitters"]
      assert_equal result.first["RDTs"], counts.first["RDTs"]
      assert_equal result.first["ONTs"], counts.first["ONTs"]
      assert_equal result.first["WAPs"], counts.first["WAPs"]
      assert_equal result.first["Rooms"], counts.first["Rooms"]
      assert_equal result.first["Active Channels"], counts.first["Active Channels"]
      assert_equal result.first["Standby Channels"], counts.first["Standby Channels"]
      assert_equal result.first["Active PON Ports"], counts.first["Active PON Ports"]
      assert_equal result.first["Spare Feeder Fibers"], counts.first["Spare Feeder Fibers"]
      assert_equal result.first["Active Distribution Ports"], counts.first["Active Distribution Ports"]
      assert_equal result.first["Spare Distribution Ports"], counts.first["Spare Distribution Ports"]
      assert_equal result.first["Actual RDT Count"], counts.first["Actual RDT Count"]

      assert_equal result[1]["BLDG"], counts[1]["BLDG"]
      assert_equal result[1]["Bldgs"], counts[1]["Bldgs"]
      assert_equal result[1]["OLTs"], counts[1]["OLTs"]
      assert_equal result[1]["PON Cards"], counts[1]["PON Cards"]
      assert_equal result[1]["FDHs"], counts[1]["FDHs"]
      assert_equal result[1]["Splitters"], counts[1]["Splitters"]
      assert_equal result[1]["RDTs"], counts[1]["RDTs"]
      assert_equal result[1]["ONTs"], counts[1]["ONTs"]
      assert_equal result[1]["WAPs"], counts[1]["WAPs"]
      assert_equal result[1]["Rooms"], counts[1]["Rooms"]
      assert_equal result[1]["Active Channels"], counts[1]["Active Channels"]
      assert_equal result[1]["Standby Channels"], counts[1]["Standby Channels"]
      assert_equal result[1]["Active PON Ports"], counts[1]["Active PON Ports"]
      assert_equal result[1]["Spare Feeder Fibers"], counts[1]["Spare Feeder Fibers"]
      assert_equal result[1]["Active Distribution Ports"], counts[1]["Active Distribution Ports"]
      assert_equal result[1]["Spare Distribution Ports"], counts[1]["Spare Distribution Ports"]
      assert_equal result[1]["Actual RDT Count"], counts[1]["Actual RDT Count"]

      assert_equal result[2]["BLDG"], counts[2]["BLDG"]
      assert_equal result[2]["Bldgs"], counts[2]["Bldgs"]
      assert_equal result[2]["OLTs"], counts[2]["OLTs"]
      assert_equal result[2]["PON Cards"], counts[2]["PON Cards"]
      assert_equal result[2]["FDHs"], counts[2]["FDHs"]
      assert_equal result[2]["Splitters"], counts[2]["Splitters"]
      assert_equal result[2]["RDTs"], counts[2]["RDTs"]
      assert_equal result[2]["ONTs"], counts[2]["ONTs"]
      assert_equal result[2]["WAPs"], counts[2]["WAPs"]
      assert_equal result[2]["Rooms"], counts[2]["Rooms"]
      assert_equal result[2]["Active Channels"], counts[2]["Active Channels"]
      assert_equal result[2]["Standby Channels"], counts[2]["Standby Channels"]
      assert_equal result[2]["Active PON Ports"], counts[2]["Active PON Ports"]
      assert_equal result[2]["Spare Feeder Fibers"], counts[2]["Spare Feeder Fibers"]
      assert_equal result[2]["Active Distribution Ports"], counts[2]["Active Distribution Ports"]
      assert_equal result[2]["Spare Distribution Ports"], counts[2]["Spare Distribution Ports"]
      assert_equal result[2]["Actual RDT Count"], counts[2]["Actual RDT Count"]

      assert_equal result, counts
    end

    it "spares_from_cable_run" do
      building = FactoryGirl.build(:building)

      cable_runs = []
      cable_run = FactoryGirl.build(:cable_run)
      cable_run.floor = "6"
      cable_run.drop = " Spare"
      cable_runs << cable_run

      cable_run = FactoryGirl.build(:cable_run)
      cable_run.floor = "ground"
      cable_run.drop = "spare"
      cable_runs << cable_run

      cable_run = FactoryGirl.build(:cable_run)
      cable_run.floor = "ground"
      cable_run.drop = " Spare "
      cable_runs << cable_run

      cable_run = FactoryGirl.build(:cable_run)
      cable_run.floor = "lobby"
      cable_run.drop = "1"
      cable_runs << cable_run

      cable_run = FactoryGirl.build(:cable_run)
      cable_run.floor = "lobby"
      cable_run.rdt = "N/A"
      cable_run.drop = "spare"
      cable_runs << cable_run

      result = [
        { label: "Floor 6", group: building.name, value: 1 },
        { label: "Ground Floor", group: building.name, value: 2 },
        { label: "Lobby Floor", group: building.name, value: 0 }
      ]

      assert_equal result, NetworkSite.send(:spares_from_cable_runs, building.name, cable_runs)
    end

    it "chart_distribution_spares_buildings" do
      network_site = FactoryGirl.create(:network_site_with_buildings)
      building_1_name = network_site.buildings.first.name
      building_2_name = network_site.buildings.last.name

      Sheet.any_instance.stubs(:cable_runs).returns(nil)

      spares1 = [
        { label: "Floor 6", group: building_1_name, value: 1 },
        { label: "Ground Floor", group: building_1_name, value: 2 },
        { label: "Lobby Floor", group: building_1_name, value: 0 }
      ]
      spares2 = [
        { label: "Floor 6", group: building_2_name, value: 1 },
        { label: "Ground Floor", group: building_2_name, value: 2 },
        { label: "Lobby Floor", group: building_2_name, value: 0 }
      ]
      NetworkSite.stubs(:spares_from_cable_runs).with(building_1_name, nil).returns(spares1)
      NetworkSite.stubs(:spares_from_cable_runs).with(building_2_name, nil).returns(spares2)

      result = [
        { label: "Floor 6", group: building_1_name, value: 1 },
        { label: "Ground Floor", group: building_1_name, value: 2 },
        { label: "Lobby Floor", group: building_1_name, value: 0 },
        { label: "Floor 6", group: building_2_name, value: 1 },
        { label: "Ground Floor", group: building_2_name, value: 2 },
        { label: "Lobby Floor", group: building_2_name, value: 0 }
      ]

      assert_equal result.sort_by { |hash| hash[:group] }, network_site.chart_distribution_spares_buildings
    end

    it "chart_distribution_spares_buildings with no cable_runs" do
      network_site = FactoryGirl.create(:network_site_with_buildings)
      building_1_name = network_site.buildings.first.name
      building_2_name = network_site.buildings.last.name

      Building.any_instance.stubs(:latest_sheet).returns(nil)

      spares1 = [
        { label: "Floor 6", group: building_1_name, value: 1 },
        { label: "Ground Floor", group: building_1_name, value: 2 },
        { label: "Lobby Floor", group: building_1_name, value: 0 }
      ]
      NetworkSite.stubs(:spares_from_cable_runs).with(building_1_name, nil).returns(spares1)

      result = []

      assert_equal result, network_site.chart_distribution_spares_buildings
    end

    it "chart_distribution_spares_buildings with no drop value" do
      network_site = FactoryGirl.create(:network_site_with_buildings)
      building_1_name = network_site.buildings.first.name
      building_2_name = network_site.buildings.last.name

      cable_run = FactoryGirl.build(:cable_run)
      cable_run.floor = "lobby"
      cable_run.rdt = "1"
      cable_run.drop = nil

      Sheet.any_instance.stubs(:cable_runs).returns([cable_run])

      result = [
        { label: "Lobby Floor", group: building_1_name, value: 0 },
        { label: "Lobby Floor", group: building_2_name, value: 0 }
      ]

      assert_equal result.first, network_site.chart_distribution_spares_buildings.first

      assert_equal result, network_site.chart_distribution_spares_buildings
    end
  end
end
