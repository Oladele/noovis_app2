class NetworkSitesController < ApiController
  def chart_distribution_ports_buildings
    network_site = NetworkSite.find(params[:id])

  	result = network_site.chart_distribution_ports_buildings

    render json: result
  end

  def chart_distribution_ports_sites
    network_site = NetworkSite.find(params[:id])

    result = network_site.chart_distribution_ports_sites

    render json: result
  end
end
