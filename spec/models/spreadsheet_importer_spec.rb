require 'rails_helper'

RSpec.describe SpreadsheetImporter, type: :model do
  describe "import" do
    it "read_cable_runs" do
      sheet = FactoryGirl.create(:sheet)
      sheet.cable_runs.create!(site: "site1", building: "building1", olt_rack: "olt1")
      sheet.cable_runs.create!(site: "site2", building: "building2", olt_rack: "olt2")

      result = [["Site", "OLT Rack", "Building"], %w(site1 olt1 building1), %w(site2 olt2 building2)]

      data = SpreadsheetImporter.read_cable_runs(["Site", "OLT Rack", "Building"], sheet.cable_runs.order(:created_at))
      assert_equal result, data
    end

    it "import from cable_runs" do
      sheet = FactoryGirl.create(:sheet)
      sheet.cable_runs.create!(site: "site1", building: "building1", olt_rack: "olt1")
      sheet.cable_runs.create!(site: "site1", building: "building2", olt_rack: "olt2")

      first_id = sheet.cable_runs.first.id
      second_id = sheet.cable_runs.last.id

      result = {
        sites: [
          {
            value: 'site1',
            cable_run_id: first_id,
            olt_racks: [
              {
                value: 'olt1',
                cable_run_id: first_id,
                buildings: [{ value: 'building1', cable_run_id: first_id }]
              },
              {
                value: 'olt2',
                cable_run_id: second_id,
                buildings: [{ value: 'building2', cable_run_id: second_id }]
              }
            ]
          }
        ]
      }

      graph = SpreadsheetImporter.import_from_cable_runs(["Site", "OLT Rack", "Building"], sheet.cable_runs.order(:created_at))

      assert_equal result, graph
    end

    it "build_structure" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: []
          }
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts, collection: :splitters }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1"]], [1])

      assert_equal graph, value
    end

    it "build_structure 2" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: 'building1',
                cable_run_id: 1,
                olts: []
              }
            ]
          }
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts, collection: :splitters }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1", "building1"]], [1])

      assert_equal graph, value
    end

    it "build_structure 3" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: 'building1',
                cable_run_id: 1,
                olts: []
              },
              {
                value: 'building2',
                cable_run_id: 2,
                olts: []
              }
            ]
          }
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts, collection: :splitters }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1", "building1"], ["site1", "building2"]], [1, 2])

      assert_equal graph, value
    end

    it "build_structure 3.55 with float values" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: '1',
                cable_run_id: 1,
                olts: []
              },
              {
                value: '2',
                cable_run_id: 2,
                olts: []
              }
            ]
          }
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts, collection: :splitters }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1", "1.0"], ["site1", "2.0"]], [1,2])

      assert_equal graph, value
    end

    it "build_structure 3.55 with integer values" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: '1',
                cable_run_id: 1,
                olts: []
              },
              {
                value: '2',
                cable_run_id: 2,
                olts: []
              }
            ]
          }
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts, collection: :splitters }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1", 1.0], ["site1", 2.0]], [1,2])

      assert_equal graph, value
    end

    it "build_structure with the same floats" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: '1',
                cable_run_id: 1,
                olts: []
              }
            ]
          }
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts, collection: :splitters }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1", 1.0], ["site1", 1.0]], [1])

      assert_equal graph, value
    end

    it "build_structure 4" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: 'building1',
                cable_run_id: 1,
                olts: []
              },
              {
                value: 'building2',
                cable_run_id: 2,
                olts: []
              }
            ]
          },
          {
            value: 'site2',
            cable_run_id: 3,
            buildings: [
              {
                value: 'building3',
                cable_run_id: 3,
                olts: []
              },
            ]
          }
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts, collection: :splitters }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1", "building1"], ["site1", "building2"], ["site2", "building3"]], [1, 2, 3])

      assert_equal graph, value
    end

    it "build_structure 4.5" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: 'building1',
                cable_run_id: 1,
                olts: []
              },
            ]
          },
          {
            value: 'site2',
            cable_run_id: 3,
            buildings: [
              {
                value: 'building3',
                cable_run_id: 3,
                olts: []
              },
            ]
          }
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts, collection: :splitters }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1", "building1"], ["site1", "building1"], ["site2", "building3"]], [1, 2, 3])

      assert_equal graph, value
    end

    it "build_structure has no duplicates" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: 'building1',
                cable_run_id: 1,
                olts: []
              },
            ]
          },
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts, collection: :splitters }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1", "building1"], ["site1", "building1"]], [1])

      assert_equal graph, value
    end

    it "build_structure 5" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: 'building1',
                cable_run_id: 1,
                olts: [
                  {
                    value: 'olt1',
                    cable_run_id: 1,
                    splitters: []
                  }
                ]
              },
            ]
          },
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts, collection: :splitters }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1", "building1", "olt1"]], [1])

      assert_equal graph, value
    end

    it "build_structure 6" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: 'building1',
                cable_run_id: 1,
                olts: [
                  {
                    value: 'olt1',
                    cable_run_id: 1,
                  }
                ]
              },
            ]
          },
          {
            value: 'site2',
            cable_run_id: 2,
            buildings: [
              {
                value: 'building2',
                cable_run_id: 2,
                olts: []
              }
            ]
          }
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1", "building1", "olt1"], ["site2", "building2"]], [1, 2])

      assert_equal graph, value
    end

    it "build_structure 6 nil check" do
      graph = {
        sites: [
          {
            value: 'site1',
            cable_run_id: 1,
            buildings: [
              {
                value: 'building1',
                cable_run_id: 1,
                olts: [
                  {
                    value: 'olt1',
                    cable_run_id: 1
                  }
                ]
              },
            ]
          },
          {
            value: 'site2',
            cable_run_id: 2,
            buildings: [
              {
                value: 'building2',
                cable_run_id: 2,
                olts: [
                  {
                    value: 'N/A',
                    cable_run_id: 2
                  }
                ]
              }
            ]
          }
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts }
      ]

      value = SpreadsheetImporter.build_structure(template, [["site1", "building1", "olt1"], ["site2", "building2", nil]], [1, 2])

      assert_equal graph, value
    end

    it "template_order" do
      data = SpreadsheetImporter.template_order(["Site", "Building", "OLT Rack"], ["Site", "OLT Rack", "Building"])

      assert_equal true, data[:success]
      assert_equal nil, data[:message]
      assert_equal [0, 2, 1], data[:spreadsheet_order]
    end

    it "template_order with invalid record" do
      data = SpreadsheetImporter.template_order(["Site", "Building", "OLT Rack"], ["Site", "OLT Rack", "asdf"])

      assert_equal false, data[:success]
      assert_equal 'Error: spreadsheet header values did not match template.', data[:message]
      assert_equal nil, data[:spreadsheet_order]
    end

    it "reorder_sheet" do
      ordered = [[1, 2, 3], [1, 2, 3]]

      value = SpreadsheetImporter.reorder_sheet([0, 2, 1], [[1, 3, 2], [1, 3, 2]])
      assert_equal ordered, value
    end

    it "imports a small but real sheet" do
      sheet = FactoryGirl.create(:sheet)
      sheet.cable_runs.create!(site: "Oakcrest", building: "Village Square", olt_rack: "olt1", olt_chassis: 'ELOC001', pon_card: '1', pon_port: '1', fdh: 'VS1', splitter: 'N/A')

      first_id = sheet.cable_runs.first.id

      result = {
        sites: [
          {
            value: 'Oakcrest',
            cable_run_id: first_id,
            olt_chassis: [
              {
                value: 'ELOC001',
                cable_run_id: first_id,
                pon_cards: [
                  {
                    value: '1',
                    cable_run_id: first_id,
                    pon_ports: [
                      {
                        value: '1',
                        cable_run_id: first_id,
                        buildings: [
                          {
                            value: 'Village Square',
                            cable_run_id: first_id,
                            fdhs: [
                              {
                                value: 'VS1',
                                cable_run_id: first_id,
                                splitters: [
                                  { value: 'N/A', cable_run_id: first_id }
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }

      network_template = ["Site", "OLT Chassis", "PON Card", "PON Port", "Building", "FDH", "Splitter"]
      assert_equal result, SpreadsheetImporter.import_from_cable_runs(network_template, sheet.cable_runs.order(:created_at))
    end

    it "imports a small but real sheet fully" do
      sheet = FactoryGirl.create(:sheet)
      sheet.cable_runs.create!(site: "Oakcrest", building: "Village Square", olt_rack: "olt1", olt_chassis: 'ELOC001', pon_card: '1', pon_port: '1', fdh: 'VS1', splitter: 'N/A', rdt: '1', room: 'N/A')

      first_id = sheet.cable_runs.first.id

      result = {
        sites: [
          {
            value: 'Oakcrest',
            cable_run_id: first_id,
            olt_chassis: [
              {
                value: 'ELOC001',
                cable_run_id: first_id,
                pon_cards: [
                  {
                    value: '1',
                    cable_run_id: first_id,
                    pon_ports: [
                      {
                        value: '1',
                        cable_run_id: first_id,
                        buildings: [
                          {
                            value: 'Village Square',
                            cable_run_id: first_id,
                            fdhs: [
                              {
                                value: 'VS1',
                                cable_run_id: first_id,
                                splitters: [
                                  {
                                    value: 'N/A',
                                    cable_run_id: first_id,
                                    rdts: [
                                      {
                                        value: '1',
                                        cable_run_id: first_id,
                                        rooms: [
                                          {
                                            value: 'N/A',
                                            cable_run_id: first_id,
                                            ont_sns: [
                                              {
                                                value: 'N/A',
                                                cable_run_id: first_id,
                                                ont_ge_1_macs: [
                                                  {
                                                    value: 'N/A',
                                                    cable_run_id: first_id,
                                                    ont_ge_2_macs: [
                                                      {
                                                        value: 'N/A',
                                                        cable_run_id: first_id,
                                                        ont_ge_3_macs: [
                                                          {
                                                            value: 'N/A',
                                                            cable_run_id: first_id,
                                                            ont_ge_4_macs: [
                                                              { value: 'N/A', cable_run_id: first_id }
                                                            ]
                                                          }
                                                        ]
                                                      }
                                                    ]
                                                  }
                                                ]
                                              }
                                            ]
                                          }
                                        ]
                                      }
                                    ]
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }

      value = SpreadsheetImporter.import_from_cable_runs(SpreadsheetImporter::NETWORK_TEMPLATE, sheet.cable_runs.order(:created_at))
      assert_equal result, value
    end

    it "imports two rows from a small but real sheet fully" do
      sheet = FactoryGirl.create(:sheet)
      sheet.cable_runs.create!(site: "Oakcrest", building: "Village Square", olt_rack: "olt1", olt_chassis: 'ELOC001', pon_card: '1', pon_port: '1', fdh: 'VS1', splitter: 'N/A', rdt: '1', room: 'N/A')
      sheet.cable_runs.create!(site: "Oakcrest 2", building: "Village Square", olt_rack: "olt1", olt_chassis: 'ELOC001', pon_card: '1', pon_port: '1', fdh: 'VS1', splitter: 'N/A', rdt: '1', room: 'N/A')

      first_id = sheet.cable_runs.first.id
      second_id = sheet.cable_runs.last.id

      result = {
        sites: [
          {
            value: 'Oakcrest',
            cable_run_id: first_id,
            olt_chassis: [
              {
                value: 'ELOC001',
                cable_run_id: first_id,
                pon_cards: [
                  {
                    value: '1',
                    cable_run_id: first_id,
                    pon_ports: [
                      {
                        value: '1',
                        cable_run_id: first_id,
                        buildings: [
                          {
                            value: 'Village Square',
                            cable_run_id: first_id,
                            fdhs: [
                              {
                                value: 'VS1',
                                cable_run_id: first_id,
                                splitters: [
                                  {
                                    value: 'N/A',
                                    cable_run_id: first_id,
                                    rdts: [
                                      {
                                        value: '1',
                                        cable_run_id: first_id,
                                        rooms: [
                                          {
                                            value: 'N/A',
                                            cable_run_id: first_id,
                                            ont_sns: [
                                              {
                                                value: 'N/A',
                                                cable_run_id: first_id,
                                                ont_ge_1_macs: [
                                                  {
                                                    value: 'N/A',
                                                    cable_run_id: first_id,
                                                    ont_ge_2_macs: [
                                                      {
                                                        value: 'N/A',
                                                        cable_run_id: first_id,
                                                        ont_ge_3_macs: [
                                                          {
                                                            value: 'N/A',
                                                            cable_run_id: first_id,
                                                            ont_ge_4_macs: [
                                                              { value: 'N/A', cable_run_id: first_id }
                                                            ]
                                                          }
                                                        ]
                                                      }
                                                    ]
                                                  }
                                                ]
                                              }
                                            ]
                                          }
                                        ]
                                      }
                                    ]
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          },
          {
            value: 'Oakcrest 2',    # This value is different
            cable_run_id: second_id,
            olt_chassis: [
              {
                value: 'ELOC001',
                cable_run_id: second_id,
                pon_cards: [
                  {
                    value: '1',
                    cable_run_id: second_id,
                    pon_ports: [
                      {
                        value: '1',
                        cable_run_id: second_id,
                        buildings: [
                          {
                            value: 'Village Square',
                            cable_run_id: second_id,
                            fdhs: [
                              {
                                value: 'VS1',
                                cable_run_id: second_id,
                                splitters: [
                                  {
                                    value: 'N/A',
                                    cable_run_id: second_id,
                                    rdts: [
                                      {
                                        value: '1',
                                        cable_run_id: second_id,
                                        rooms: [
                                          {
                                            value: 'N/A',
                                            cable_run_id: second_id,
                                            ont_sns: [
                                              {
                                                value: 'N/A',
                                                cable_run_id: second_id,
                                                ont_ge_1_macs: [
                                                  {
                                                    value: 'N/A',
                                                    cable_run_id: second_id,
                                                    ont_ge_2_macs: [
                                                      {
                                                        value: 'N/A',
                                                        cable_run_id: second_id,
                                                        ont_ge_3_macs: [
                                                          {
                                                            value: 'N/A',
                                                            cable_run_id: second_id,
                                                            ont_ge_4_macs: [
                                                              { value: 'N/A', cable_run_id: second_id }
                                                            ]
                                                          }
                                                        ]
                                                      }
                                                    ]
                                                  }
                                                ]
                                              }
                                            ]
                                          }
                                        ]
                                      }
                                    ]
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }

      value = SpreadsheetImporter.import_from_cable_runs(SpreadsheetImporter::NETWORK_TEMPLATE, sheet.cable_runs.order(:created_at))
      assert_equal result, value
    end

    it "makes the template" do
      result = [
        { type: :sites, collection: :olt_chassis },
        { type: :olt_chassis, collection: :pon_cards },
        { type: :pon_cards }
      ]

      template = ["Site", "OLT Chassis", "PON Card"]

      assert_equal result, SpreadsheetImporter.structure_for_network_template(template)
    end

    it "format" do
      assert_equal :pon_cards, SpreadsheetImporter.format('PON Card')
      assert_equal :sites, SpreadsheetImporter.format('Site')
      assert_equal :olt_chassis, SpreadsheetImporter.format('OLT Chassis')
      assert_equal :rooms, SpreadsheetImporter.format('Room Number')
      assert_equal :ont_sns, SpreadsheetImporter.format('ONT SN#')
      assert_equal :ont_ge_1_macs, SpreadsheetImporter.format('ONT GE Port 1 Mac')
    end
  end
end
