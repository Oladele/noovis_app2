require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NoovisApp2
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Rack CORS gem suggested by Sean Devine
    # In Charity App screencasts #12
    # Config culled from gem docs Rails 4 Example application.rb
    # https://github.com/cyu/rack-cors/blob/master/examples/rails4/config/application.rb

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'

        resource '*',
            :headers => :any,
            :expose => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
            :methods => [:get, :post, :delete, :put, :patch, :options, :head],
            :max_age => 0
      end
    end

    config.autoload_paths += %W(#{config.root}/lib)
  end
end
