class AddLatLngToNetworkSite < ActiveRecord::Migration
  def change
    add_column :network_sites, :lat, :decimal, precision: 10, scale: 6
    add_column :network_sites, :lng, :decimal, precision: 10, scale: 6
  end
end
