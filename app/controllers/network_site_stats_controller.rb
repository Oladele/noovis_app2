class NetworkSiteStatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_network_site

  def chart_distribution_ports_buildings
    render json: @network_site.chart_distribution_ports_buildings
  end

  def chart_distribution_ports_site
    render json: @network_site.chart_distribution_ports_site
  end

  def chart_feeder_capacity_buildings
    render json: @network_site.chart_feeder_capacity_buildings
  end

  def chart_feeder_capacity_site
    render json: @network_site.chart_feeder_capacity_site
  end

  def chart_pon_usage_buildings
    render json: @network_site.chart_pon_usage_buildings
  end

  def chart_pon_usage_site
    render json: @network_site.chart_pon_usage_site
  end

  def network_element_counts
    render json: @network_site.network_element_counts
  end

  def chart_distribution_spares_buildings
    render json: @network_site.chart_distribution_spares_buildings
  end

  private
    def set_network_site
      @network_site = NetworkSite.find(params[:id])
    end
end
