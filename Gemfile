source 'https://rubygems.org'

ruby '2.2.4'

gem 'rails', '4.2.4'
gem 'pg'
gem 'bcrypt', '~> 3.1.7'
gem 'unicorn'
gem 'newrelic_rpm'
gem 'sidekiq', '~> 4.1', '>= 4.1.1'
gem 'passenger', '~> 5.0', '>= 5.0.27'

#app-specific gems
gem 'rspec_api_documentation'
gem 'jsonapi-resources', git: 'https://github.com/cerebris/jsonapi-resources', ref: '8a2bd30b00a6ee270baa71c0642a9fb7c14c5d83'
gem "apitome"
# Rack CORS gem suggested by Sean Devine
# In Charity App screencasts #12
gem 'rack-cors', :require => 'rack/cors'
gem 'roo'
gem 'roo-xls'
gem 'devise_token_auth'
gem 'omniauth'
gem 'paper_trail'

# http://stackoverflow.com/questions/28374401/nameerror-uninitialized-constant-paperclipstorages3aws
gem 'paperclip', :git=> 'https://github.com/thoughtbot/paperclip', :ref => '523bd46c768226893f23889079a7aa9c73b57d68'
gem 'aws-sdk', '~> 2.2', '>= 2.2.35'

gem 'sinatra', :require => nil
gem 'dalli', '~> 2.7', '>= 2.7.6'

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
