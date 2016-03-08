class NodeResource < JSONAPI::Resource
  attributes :node_value, :node_level, :x_pos, :y_pos
  has_one :network_graph
  has_one :node_type

  filter :network_graph, :node_type
end
