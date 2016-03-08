class Node < ActiveRecord::Base
  belongs_to :network_graph
  belongs_to :node_type
end
