require 'rails_helper'

RSpec.describe Testy, type: :model do
  describe "import" do
    #it "Should do things" do
      #graph = {
        #site1: {
          #building1: {

          #}
        #},
        ##site2: {
        ##}
      #}

      #assert_equal graph, Testy.import
    #end

    #it "sdflkj" do
      #graph = {
        #site1: {
          #building1: {
            #elt1: {

            #}

          #}
        #},
        ##site2: {
        ##}
      #}

      #value = Testy.save_piece({}, [:site1, :building1, :elt1])

      #assert_equal graph, value
    #end

    #it "two" do
      #graph = {
        #site1: {
          #building1: {
          #}
        #},
      #}

      #value = Testy.new_import([[:site1, :building1], [:site1, :building1]])

      #assert_equal graph, value
    #end

    #it "mult" do
      #graph = {
        #site1: {
          #building1: {
          #},
          #building2: {
          #}
        #},
      #}

      #value = Testy.new_import([[:site1, :building1], [:site1, :building2]])

      #assert_equal graph, value
    #end

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
  end
end
