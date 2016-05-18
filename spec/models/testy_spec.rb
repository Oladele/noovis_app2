require 'rails_helper'

RSpec.describe Testy, type: :model do
  describe "import" do
    it "import2" do
      graph = {
        sites: [
          {
            value: 'site1',
            buildings: []
          }
        ]
      }

      template = [
        { type: :sites, collection: :buildings },
        { type: :buildings, collection: :olts },
        { type: :olts, collection: :splitters }
      ]

      value = Testy.import2(template, [["site1"]])

      assert_equal graph, value
    end

    it "import2 2" do
      graph = {
        sites: [
          {
            value: 'site1',
            buildings: [
              {
                value: 'building1',
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

      value = Testy.import2(template, [["site1", "building1"]])

      assert_equal graph, value
    end

    it "import2 3" do
      graph = {
        sites: [
          {
            value: 'site1',
            buildings: [
              {
                value: 'building1',
                olts: []
              },
              {
                value: 'building2',
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

      value = Testy.import2(template, [["site1", "building1"], ["site1", "building2"]])

      assert_equal graph, value
    end

    it "import2 3.55 with integer values" do
      graph = {
        sites: [
          {
            value: 'site1',
            buildings: [
              {
                value: '1',
                olts: []
              },
              {
                value: '2',
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

      value = Testy.import2(template, [["site1", 1.0], ["site1", 2.0]])

      assert_equal graph, value
    end

    it "import2 4" do
      graph = {
        sites: [
          {
            value: 'site1',
            buildings: [
              {
                value: 'building1',
                olts: []
              },
              {
                value: 'building2',
                olts: []
              }
            ]
          },
          {
            value: 'site2',
            buildings: [
              {
                value: 'building3',
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

      value = Testy.import2(template, [["site1", "building1"], ["site1", "building2"], ["site2", "building3"]])

      assert_equal graph, value
    end

    it "import2 4.5" do
      graph = {
        sites: [
          {
            value: 'site1',
            buildings: [
              {
                value: 'building1',
                olts: []
              },
            ]
          },
          {
            value: 'site2',
            buildings: [
              {
                value: 'building3',
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

      value = Testy.import2(template, [["site1", "building1"], ["site1", "building1"], ["site2", "building3"]])

      assert_equal graph, value
    end

    it "import2 5" do
      graph = {
        sites: [
          {
            value: 'site1',
            buildings: [
              {
                value: 'building1',
                olts: [
                  {
                    value: 'olt1',
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

      value = Testy.import2(template, [["site1", "building1", "olt1"]])

      assert_equal graph, value
    end

    it "import2 6" do
      graph = {
        sites: [
          {
            value: 'site1',
            buildings: [
              {
                value: 'building1',
                olts: [
                  {
                    value: 'olt1',
                  }
                ]
              },
            ]
          },
          {
            value: 'site2',
            buildings: [
              {
                value: 'building2',
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

      value = Testy.import2(template, [["site1", "building1", "olt1"], ["site2", "building2"]])

      assert_equal graph, value
    end

    it "import2 6 nil check" do
      graph = {
        sites: [
          {
            value: 'site1',
            buildings: [
              {
                value: 'building1',
                olts: [
                  {
                    value: 'olt1',
                  }
                ]
              },
            ]
          },
          {
            value: 'site2',
            buildings: [
              {
                value: 'building2',
                olts: [
                  {
                    value: 'N/A'
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

      value = Testy.import2(template, [["site1", "building1", "olt1"], ["site2", "building2", nil]])

      assert_equal graph, value
    end

    it "template_order" do
      assert_equal [0, 2, 1], Testy.template_order(["Site", "Building", "OLT Rack"], ["Site", "OLT Rack", "Building"])
    end

    it "template_order with invalid record" do
      assert_equal 'ordering error', Testy.template_order(["Site", "Building", "OLT Rack"], ["Site", "OLT Rack", "asdf"])
    end

    it "template_order" do
      ordered = [[1, 2, 3], [1, 2, 3]]

      value = Testy.reorder_sheet([0, 2, 1], [[1, 3, 2], [1, 3, 2]])
      assert_equal ordered, value
    end

    it "reads the spreadsheet into values" do
      file = File.join(Rails.root, "spec/support/import_refactor_spreadsheets/import_reordering_test.xls")

      result = [["Site", "OLT Rack", "Building"], %w(one three two), %w(one three two)]

      assert_equal result, Testy.read_spreadsheet(file, 'Sheet 1')
    end

    it "reads the spreadsheet into values" do
      file = File.join(Rails.root, "spec/support/import_refactor_spreadsheets/import_reordering_test_bad.xls")

      assert_equal 'read spreadsheet error', Testy.read_spreadsheet(file, 'Sheet 1')
    end

    it "ordered spreadsheet" do
      file = File.join(Rails.root, "spec/support/import_refactor_spreadsheets/import_reordering_test.xls")

      result = {
        sites: [
          {
            value: 'one',
            buildings: [
              {
                value: 'two',
                olt_racks: [
                  {
                    value: 'three',
                  },
                ]
              },
            ]
          },
        ]
      }

      network_template = ["Site", "Building", "OLT Rack"]
      assert_equal result, Testy.do_it(network_template, file, 'Sheet 1')
    end

    it "imports a small but real sheet" do
      file = File.join(Rails.root, "spec/support/import_refactor_spreadsheets/small_but_real.xls")

      result = {
        sites: [
          {
            value: 'Oakcrest',
            olt_chasses: [
              {
                value: 'ELOC001',
                pon_cards: [
                  {
                    value: '1',
                    pon_ports: [
                      {
                        value: '1',
                        buildings: [
                          {
                            value: 'Village Square',
                            fdhs: [
                              {
                                value: 'VS1',
                                splitters: [
                                  { value: 'N/A' }
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
      assert_equal result, Testy.do_it(network_template, file, 'Village Square')
    end

    it "imports a small but real sheet fully" do
      file = File.join(Rails.root, "spec/support/import_refactor_spreadsheets/small_but_real.xls")

      result = {
        sites: [
          {
            value: 'Oakcrest',
            olt_chasses: [
              {
                value: 'ELOC001',
                pon_cards: [
                  {
                    value: '1',
                    pon_ports: [
                      {
                        value: '1',
                        buildings: [
                          {
                            value: 'Village Square',
                            fdhs: [
                              {
                                value: 'VS1',
                                splitters: [
                                  {
                                    value: 'N/A',
                                    rdts: [
                                      {
                                        value: '1',
                                        rooms: [
                                          {
                                            value: 'N/A',
                                            ont_sns: [
                                              {
                                                value: 'N/A',
                                                ont_ge_1_macs: [
                                                  {
                                                    value: 'N/A',
                                                    ont_ge_2_macs: [
                                                      {
                                                        value: 'N/A',
                                                        ont_ge_3_macs: [
                                                          {
                                                            value: 'N/A',
                                                            ont_ge_4_macs: [
                                                              { value: 'N/A' }
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

      network_template = ["Site", "OLT Chassis", "PON Card", "PON Port", "Building", "FDH", "Splitter", "RDT",
                          "Room Number", "ONT SN#", "ONT GE Port 1 MAC", "ONT GE Port 2 MAC", "ONT GE Port 3 MAC", "ONT GE Port 4 MAC"]

      value = Testy.do_it(network_template, file, 'Village Square')
      assert_equal result, value
    end

    it "imports two rows from a small but real sheet fully" do
      file = File.join(Rails.root, "spec/support/import_refactor_spreadsheets/two_rows_small_but_real.xls")

      result = {
        sites: [
          {
            value: 'Oakcrest',
            olt_chasses: [
              {
                value: 'ELOC001',
                pon_cards: [
                  {
                    value: '1',
                    pon_ports: [
                      {
                        value: '1',
                        buildings: [
                          {
                            value: 'Village Square',
                            fdhs: [
                              {
                                value: 'VS1',
                                splitters: [
                                  {
                                    value: 'N/A',
                                    rdts: [
                                      {
                                        value: '1',
                                        rooms: [
                                          {
                                            value: 'N/A',
                                            ont_sns: [
                                              {
                                                value: 'N/A',
                                                ont_ge_1_macs: [
                                                  {
                                                    value: 'N/A',
                                                    ont_ge_2_macs: [
                                                      {
                                                        value: 'N/A',
                                                        ont_ge_3_macs: [
                                                          {
                                                            value: 'N/A',
                                                            ont_ge_4_macs: [
                                                              { value: 'N/A' }
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
            olt_chasses: [
              {
                value: 'ELOC001',
                pon_cards: [
                  {
                    value: '1',
                    pon_ports: [
                      {
                        value: '1',
                        buildings: [
                          {
                            value: 'Village Square',
                            fdhs: [
                              {
                                value: 'VS1',
                                splitters: [
                                  {
                                    value: 'N/A',
                                    rdts: [
                                      {
                                        value: '1',
                                        rooms: [
                                          {
                                            value: 'N/A',
                                            ont_sns: [
                                              {
                                                value: 'N/A',
                                                ont_ge_1_macs: [
                                                  {
                                                    value: 'N/A',
                                                    ont_ge_2_macs: [
                                                      {
                                                        value: 'N/A',
                                                        ont_ge_3_macs: [
                                                          {
                                                            value: 'N/A',
                                                            ont_ge_4_macs: [
                                                              { value: 'N/A' }
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

      network_template = ["Site", "OLT Chassis", "PON Card", "PON Port", "Building", "FDH", "Splitter", "RDT",
                          "Room Number", "ONT SN#", "ONT GE Port 1 MAC", "ONT GE Port 2 MAC", "ONT GE Port 3 MAC", "ONT GE Port 4 MAC"]

      value = Testy.do_it(network_template, file, 'Village Square')
      assert_equal result, value
    end

    it "makes the template" do
      result = [
        { type: :sites, collection: :olt_chasses },
        { type: :olt_chasses, collection: :pon_cards },
        { type: :pon_cards }
      ]

      template = ["Site", "OLT Chassis", "PON Card"]

      assert_equal result, Testy.build_template_from_network_template(template)
    end

    it "format" do
      assert_equal :pon_cards, Testy.format('PON Card')
      assert_equal :sites, Testy.format('Site')
      assert_equal :olt_chasses, Testy.format('OLT Chassis')
      assert_equal :rooms, Testy.format('Room Number')
      assert_equal :ont_sns, Testy.format('ONT SN#')
      assert_equal :ont_ge_1_macs, Testy.format('ONT GE Port 1 Mac')
    end
  end
end
