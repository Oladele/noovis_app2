RSpec.configure do |config|

	# loads methods like "FactoryGirl.create" into the global context
  config.include FactoryGirl::Syntax::Methods

  # comment below
  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end

=begin

# Thoughbot Testing Rails:
This file will lint your factories before the test suite is run. That is, it will ensure that all the factories you define are valid. While not necessary, this is a worthwhile check, especially while you are learning. It’s a quick way to rest easy that your factories work. Since FactoryGirl.lint may end up persisting some records to the database, we use Database Cleaner to restore the state of the database after we’ve linted our factories.

...

While we’ll be calling .create in the global context to keep our code cleaner, you may see people calling it more explicitly: FactoryGirl.create. This is simply a matter of preference, and both are acceptable.

=end