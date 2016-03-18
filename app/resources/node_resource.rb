class NodeResource < JSONAPI::Resource
  attributes :node_value, :node_level, :node_type
  has_one :network_graph

  filter :network_graph
end
