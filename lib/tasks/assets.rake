# Don't precompile assets on heroku since this is an API.
# https://gist.github.com/Geesu/d0b58488cfae51f361c6
Rake::Task["assets:precompile"].clear
namespace :assets do
  task 'precompile' do
    puts "Not pre-compiling assets..."
  end
end
