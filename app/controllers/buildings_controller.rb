class BuildingsController < ApiController

	def latest_network_graph
		response = nil
		building = Building.find params[:id]

    #test_network_graph = building.test_network_graphs.order(created_at: :desc).first

    #if test_network_graph.present?
      #render json: test_network_graph.to_node_and_edges
    #else
			#message = "A network graph could not be found for #{building.name}"
			#render status: :unprocessable_entity, json: { message: message }
    #end

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
