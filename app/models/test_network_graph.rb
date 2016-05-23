class TestNetworkGraph < ActiveRecord::Base
  belongs_to :building

  validates :graph, presence: true

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

  def nodes
    iteration_helper = IterationHelper.new(1)
    nodes = []

    graph["sites"].each do |site|
      collection = site[site.keys.last]

      self.recurs(nodes, 1, iteration_helper, site.keys.last.to_s.singularize, collection, nil)
    end

    nodes
  end

  def recurs(nodes, node_level, iteration_helper, node_type, collection, parent_id)
    collection.each do |object|
      nodes << {
        id: iteration_helper.index,
        label: "#{node_type.upcase}: #{object["value"]}",
        cable_run_id: 22,
        network_graph_id: 55,
        node_level: node_level,
        node_type: node_type,
        node_value: object["value"],
        parent_id: parent_id,
        created_at: 'x',
        updated_at: 'x'
      }
      iteration_helper.increment

      nested_collection = object[object.keys.last]

      if nested_collection.present?
        # TODO: see network_graph.rb:144
        self.recurs(nodes, node_level + 1, iteration_helper, object.keys.last.to_s.singularize, nested_collection, iteration_helper.index - 1)
      end
    end
  end

  def edges
    iteration_helper = IterationHelper.new(1)
    edges = []

    graph["sites"].each do |site|
      collection = site[site.keys.last.to_s]

      self.recurs_edges(edges, 1, iteration_helper, collection, nil)
    end

    edges
  end

  # TODO: might be able to refactor this into the other similar method
  def recurs_edges(edges, edge_level, iteration_helper, collection, previous)
    collection.each do |object|
      edges << {
        id: iteration_helper.index,
        network_graph_id: 55,
        to_node_id: nil,  # Set by `previous` in next iteration
        from_node_id: previous.present? ? previous[:id] : nil,
        edge_level: edge_level,
        created_at: 'x',
        updated_at: 'x'
      }

      # Set the previous node's `to`
      previous[:to_node_id] = iteration_helper.index if previous.present?

      iteration_helper.increment

      nested_collection = object[object.keys.last]

      if nested_collection.present?
        self.recurs_edges(edges, edge_level + 1, iteration_helper, nested_collection, edges.last)
      end
    end
  end
end
