Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  resource :import_cable_run
  jsonapi_resources :users
  jsonapi_resource :global
  jsonapi_resources :cable_runs
  jsonapi_resources :companies
  jsonapi_resources :network_sites
  jsonapi_resources :buildings
  jsonapi_resources :workbooks
  jsonapi_resources :sheets
  jsonapi_resources :network_templates
  jsonapi_resources :network_graphs

  get 'network-sites/:id/chart-distribution-ports-buildings', to: 'network_site_stats#chart_distribution_ports_buildings'
  get 'network-sites/:id/chart-distribution-ports-site', to: 'network_site_stats#chart_distribution_ports_site'
  get 'network-sites/:id/chart-feeder-capacity-buildings', to: 'network_site_stats#chart_feeder_capacity_buildings'
  get 'network-sites/:id/chart-feeder-capacity-site', to: 'network_site_stats#chart_feeder_capacity_site'
  get 'network-sites/:id/chart-pon-usage-buildings', to: 'network_site_stats#chart_pon_usage_buildings'
  get 'network-sites/:id/chart-pon-usage-site', to: 'network_site_stats#chart_pon_usage_site'
  get 'network-sites/:id/network-element-counts', to: 'network_site_stats#network_element_counts'

  get 'buildings/:id/latest_network_graph', to: 'buildings#latest_network_graph'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: redirect("/api/docs")

  require "sidekiq/web"

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?

  mount Sidekiq::Web, at: "/sidekiq"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
