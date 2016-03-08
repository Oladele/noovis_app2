class Node < ActiveRecord::Base
  belongs_to :network_graph
  belongs_to :node_type

  validates :network_graph_id, presence: true
  validates :node_type_id, presence: true
end
