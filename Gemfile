source 'https://rubygems.org'

gem 'rails', '4.2.4'
gem 'pg'
gem 'bcrypt', '~> 3.1.7'
gem 'puma'

#app-specific gems
gem 'rspec_api_documentation'
gem 'jsonapi-resources'
gem "apitome"
# Rack CORS gem suggested by Sean Devine
# In Charity App screencasts #12
gem 'rack-cors', :require => 'rack/cors'

group :development do
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem 'byebug'
  #app-specific gems
  gem 'rspec-rails', '~> 3.0'
  gem "factory_girl_rails"
end

#app-specific gems
group :test do
  gem "database_cleaner"
  gem 'shoulda-matchers', '~> 3.0'
end

group :production do
  gem "rails_12factor"
end
