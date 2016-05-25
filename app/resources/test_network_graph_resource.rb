class TestNetworkGraphResource < JSONAPI::Resource
  attributes :nodes, :edges

  def nodes
    cached_nodes_and_edges[:nodes]
  end

  def edges
    cached_nodes_and_edges[:edges]
  end

  private
    def cached_nodes_and_edges
      @nodes_and_edges ||= self.model.nodes_and_edges
      @nodes_and_edges
    end
end
