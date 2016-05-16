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

      value = Testy.import2([["site1"]])

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

      value = Testy.import2([["site1", "building1"]])

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

      value = Testy.import2([["site1", "building1"], ["site1", "building2"]])

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

      value = Testy.import2([["site1", "building1"], ["site1", "building2"], ["site2", "building3"]])

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

      value = Testy.import2([["site1", "building1"], ["site1", "building1"], ["site2", "building3"]])

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

      value = Testy.import2([["site1", "building1", "olt1"]])

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
                    splitters: []
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

      value = Testy.import2([["site1", "building1", "olt1"], ["site2", "building2"]])

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
                    splitters: []
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

      value = Testy.import2([["site1", "building1", "olt1"], ["site2", "building2", nil]])

      assert_equal graph, value
    end

    it "template_order" do
      assert_equal [0, 2, 1], Testy.template_order(["Site", "OLT Rack", "Building"])
    end

    it "template_order with invalid record" do
      ordered = ["Site", "Building", "OLT Rack"]

      assert_equal 'error', Testy.template_order(["Site", "OLT Rack", "asdf"])
    end

    it "template_order" do
      ordered = [[1, 2, 3], [1, 2, 3]]

      value = Testy.reorder_sheet([0, 2, 1], [[1, 3, 2], [1, 3, 2]])
      assert_equal ordered, value
    end

    it "reads the spreadsheet into values" do
      file = File.join(Rails.root, "import_reordering_test.xls")

      result = [["Site", "OLT Rack", "Building"], [1, 3, 2], [1, 3, 2]]

      assert_equal result, Testy.read_spreadsheet(file)
    end
  end
end
