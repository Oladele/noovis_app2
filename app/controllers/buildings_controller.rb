class BuildingsController < ApiController

	def latest_network_graph
		response = nil
		building = Building.find params[:id]

    network_graph = NetworkGraph.latest_for building

    if network_graph
      response = JSONAPI::ResourceSerializer.new(NetworkGraphResource).serialize_to_hash(NetworkGraphResource.new(network_graph, nil))
      render json: response
    else
      message = "A network graph could not be found for #{building.name}"
      render status: :unprocessable_entity, json: { message: message }
    end
	end
end
