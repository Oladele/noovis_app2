class BuildingsController < ApiController

	def latest_network_graph
		response = nil
		building = Building.find params[:id]

    network_graph = NetworkGraph.latest_for building

    if network_graph
      response = JSONAPI::ResourceSerializer.new(NetworkGraphResource).serialize_to_hash(NetworkGraphResource.new(network_graph, nil))
      render json: response
    else
      render json: { graph: {} }
    end
	end
end
