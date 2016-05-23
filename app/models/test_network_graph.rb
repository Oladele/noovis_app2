class TestNetworkGraph < ActiveRecord::Base
  belongs_to :building

  validates :graph, presence: true

  def to_node_and_edges
    nodes = []
    edges = []

  end

  # An integer is passed by value, so when looping we need to retrieve and increment the same value,
  # not a copy of the value. Wrapping this in an object gives us the same pass by reference-ness of objects.
  class IterationHelper
    attr_accessor :index

    def initialize(index)
      self.index = index
    end

    def increment
      self.index += 1
    end
  end

  def self.nodes(graph)
    iteration_helper = IterationHelper.new(1)
    nodes = []

    graph[:sites].each do |site|
      collection = site[site.keys.last]

      self.recurs(nodes, 1, iteration_helper, site.keys.last.to_s.singularize, collection, nil)
    end

    nodes
  end

  def self.recurs(nodes, node_level, iteration_helper, node_type, collection, parent_id)
    collection.each do |object|
      nodes << {
        id: iteration_helper.index,
        created_at: 'x',
        label: "#{node_type.upcase}: #{object[:value]}",
        network_graph_id: 55,
        node_level: node_level,
        parent_id: parent_id,
        node_type: node_type,
        updated_at: 'x'
      }
      iteration_helper.increment

      nested_collection = object[object.keys.last]

      if nested_collection.present?
        self.recurs(nodes, node_level + 1, iteration_helper, object.keys.last.to_s.singularize, nested_collection, iteration_helper.index - 1)
      end
    end
  end
end
