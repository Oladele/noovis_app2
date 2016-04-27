source 'https://rubygems.org'

gem 'rails', '4.2.4'
gem 'pg'
gem 'bcrypt', '~> 3.1.7'
gem 'unicorn'
gem 'newrelic_rpm'
gem 'sidekiq', '~> 4.1', '>= 4.1.1'
gem 'passenger', '~> 5.0', '>= 5.0.27'

#app-specific gems
gem 'rspec_api_documentation'
gem 'jsonapi-resources'
gem "apitome"
# Rack CORS gem suggested by Sean Devine
# In Charity App screencasts #12
gem 'rack-cors', :require => 'rack/cors'
gem 'roo'
gem 'roo-xls'
gem 'devise_token_auth'
gem 'omniauth'
gem 'paperclip', '~> 4.3', '>= 4.3.6'

group :development do
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem 'dotenv-rails', '~> 2.1', '>= 2.1.1'
  gem 'byebug'
  gem 'pry', '~> 0.10.3'
  #app-specific gems
  gem 'rspec-rails', '~> 3.0'
  gem "factory_girl_rails"
  gem 'annotate'
end

#app-specific gems
group :test do
  gem "database_cleaner"
  gem 'shoulda-matchers', '~> 3.0'
  gem 'mocha', '~> 1.1'
  gem 'rspec-sidekiq', '~> 2.2'
end

group :production do
  gem "rails_12factor"
end
