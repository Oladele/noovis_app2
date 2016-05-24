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

  def nodes_and_edges
    nodes = []
    edges = []

    iteration_helper = IterationHelper.new(1)

    graph["sites"].each do |site|
      collection = site[site.keys.last]

      self.go(nodes, edges, collection, iteration_helper, site.keys.last.to_s.singularize, 1, 1, nil)
    end

    { nodes: nodes, edges: edges }
  end

  def go(nodes, edges, collection, iteration_helper, node_type, node_level, edge_level, parent_id)
    collection.each do |object|
      node = {
        id: iteration_helper.index,
        label: "#{node_type.upcase}: #{object["value"]}",
        cable_run_id: 22,
        network_graph_id: 55,
        node_level: node_level,
        node_type: node_type,
        node_value: object["value"],
        parent_id: parent_id,
        created_at: self.created_at,
        updated_at: self.updated_at
      }
      nodes << node

      # If there is a parent, then we need to make an edge.
      if parent_id.present?
        edges << {
          id: iteration_helper.index - 1,   # Offset so it starts on index 1, since it passes the first loop.
          network_graph_id: 55,
          to_node_id: node[:id],
          from_node_id: parent_id,
          edge_level: edge_level - 1,
          created_at: self.created_at,
          updated_at: self.updated_at
        }
      end

      iteration_helper.increment

      nested_collection = object[object.keys.last]

      if nested_collection.present?
        # Ports have the same node level and parent_id
        is_port_node = ["ont_ge_2_macs", "ont_ge_3_macs", "ont_ge_4_macs"].include?(object.keys.last)
        next_node_level = is_port_node ? node_level : node_level + 1
        previous_parent_id = is_port_node ? parent_id : iteration_helper.index - 1

        self.go(nodes, edges, nested_collection, iteration_helper, object.keys.last.to_s.singularize, next_node_level, next_node_level, node[:id])
      end
    end
  end

  #def recurs(nodes, edges, node_level, iteration_helper, node_type, collection, parent_id)
    #collection.each do |object|
      #nodes << {
        #id: iteration_helper.index,
        #label: "#{node_type.upcase}: #{object["value"]}",
        #cable_run_id: 22,
        #network_graph_id: 55,
        #node_level: node_level,
        #node_type: node_type,
        #node_value: object["value"],
        #parent_id: parent_id,
        #created_at: self.created_at,
        #updated_at: self.updated_at
      #}
      #iteration_helper.increment

      #nested_collection = object[object.keys.last]

      #if nested_collection.present?
        ## Ports have the same node level and parent_id
        #is_port_node = ["ont_ge_2_macs", "ont_ge_3_macs", "ont_ge_4_macs"].include?(object.keys.last)
        #next_node_level = is_port_node ? node_level : node_level + 1
        #previous_parent_id = is_port_node ? parent_id : iteration_helper.index - 1

        #self.recurs(nodes, next_node_level, iteration_helper, object.keys.last.to_s.singularize, nested_collection, previous_parent_id)
      #end

  #end

  #def nodes
    #iteration_helper = IterationHelper.new(1)
    #nodes = []

    #graph["sites"].each do |site|
      #collection = site[site.keys.last]

      #self.recurs(nodes, 1, iteration_helper, site.keys.last.to_s.singularize, collection, nil)
    #end

    #nodes
  #end

  #def recurs(nodes, node_level, iteration_helper, node_type, collection, parent_id)
    #collection.each do |object|
      #nodes << {
        #id: iteration_helper.index,
        #label: "#{node_type.upcase}: #{object["value"]}",
        #cable_run_id: 22,
        #network_graph_id: 55,
        #node_level: node_level,
        #node_type: node_type,
        #node_value: object["value"],
        #parent_id: parent_id,
        #created_at: self.created_at,
        #updated_at: self.updated_at
      #}
      #iteration_helper.increment

      #nested_collection = object[object.keys.last]

      #if nested_collection.present?
        ## Ports have the same node level and parent_id
        #is_port_node = ["ont_ge_2_macs", "ont_ge_3_macs", "ont_ge_4_macs"].include?(object.keys.last)
        #next_node_level = is_port_node ? node_level : node_level + 1
        #previous_parent_id = is_port_node ? parent_id : iteration_helper.index - 1

        #self.recurs(nodes, next_node_level, iteration_helper, object.keys.last.to_s.singularize, nested_collection, previous_parent_id)
      #end
    #end
  #end

  #def edges(nodes)
    #iteration_helper = IterationHelper.new(1)
    #edges = []

    #graph["sites"].each do |site|
      #collection = site[site.keys.last.to_s]

      #self.recurs_edges(edges, 1, iteration_helper, collection, nil)
    #end

    #edges
  #end

  #def recurs_edges(edges, edge_level, iteration_helper, collection, previous)
    #collection.each do |object|
      #nested_collection = object[object.keys.last]

      ## If there's no further nodes, we don't need to make more edges.
      #if nested_collection.present?
        #edges << {
          #id: iteration_helper.index,
          #network_graph_id: 55,
          #to_node_id: nil,  # Set by `previous` in next iteration
          #from_node_id: previous.present? ? previous[:id] : nil,
          #edge_level: edge_level,
          #created_at: self.created_at,
          #updated_at: self.updated_at
        #}

        ## Set the previous node's `to`
        #previous[:to_node_id] = iteration_helper.index if previous.present?

        #iteration_helper.increment

        ## If there's more nested object, continue on.
        #nested_collection = object[object.keys.last]

        #if nested_collection.present?
          ## Ports have the same node level and parent_id
          #is_port_node = ["ont_ge_2_macs", "ont_ge_3_macs", "ont_ge_4_macs"].include?(object.keys.last)

          #next_edge_level = is_port_node ? edge_level : edge_level + 1
          #previous_parent = is_port_node ? previous : iteration_helper.index - 1

          #self.recurs_edges(edges, edge_level + 1, iteration_helper, nested_collection, edges.last)
        #end
      #end
    #end
  #end

  #def _edges
    #iteration_helper = IterationHelper.new(1)
    #edges = []

    #graph["sites"].each do |site|
      #collection = site[site.keys.last.to_s]

      #self.recurs_edges(edges, 1, iteration_helper, collection, nil)
    #end

    #edges
  #end

  #def _recurs_edges(edges, edge_level, iteration_helper, collection, previous)
    #collection.each do |object|
      #edges << {
        #id: iteration_helper.index,
        #network_graph_id: 55,
        #to_node_id: nil,  # Set by `previous` in next iteration
        #from_node_id: previous.present? ? previous[:id] : nil,
        #edge_level: edge_level,
        #created_at: self.created_at,
        #updated_at: self.updated_at
      #}

      ## Set the previous node's `to`
      #previous[:to_node_id] = iteration_helper.index if previous.present?

      #iteration_helper.increment

      #nested_collection = object[object.keys.last]

      #if nested_collection.present?
        ## Ports have the same node level and parent_id
        #is_port_node = ["ont_ge_2_macs", "ont_ge_3_macs", "ont_ge_4_macs"].include?(object.keys.last)

        #next_edge_level = is_port_node ? edge_level : edge_level + 1
        ##previous_parent = is_port_node ? previous : iteration_helper.index - 1

        #self.recurs_edges(edges, edge_level + 1, iteration_helper, nested_collection, edges.last)
      #end
    #end
  #end
end
