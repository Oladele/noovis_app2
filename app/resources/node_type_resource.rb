class NodeTypeResource < JSONAPI::Resource
  attributes :name, :picture
  has_many :nodes
end
