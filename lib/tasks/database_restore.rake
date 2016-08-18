namespace :db do
  namespace :restore do
    # https://gist.github.com/abstractcoder/5886291
    desc 'Backups up heroku database from staging and restores it locally'
    task staging: :environment do
      # curl complains if file doesn't already exist
      `touch noovis2-staging.dump`

      # Load the current environments database config
      c = Rails.configuration.database_configuration[Rails.env]

      puts 'Capturing backup.'

      Bundler.with_clean_env do
        # Capture new backup, delete oldest manual backup if limit reached
        `heroku pg:backups capture --app noovis2-staging`

        # Download the backup to a file called noovis2-staging.dump, consider adding this file to .gitignore
        `curl -o noovis2-staging.dump \`heroku pg:backups public-url --app noovis2-staging\``

        puts 'Restoring.'

        # Restore
        `pg_restore --verbose --clean --no-acl --no-owner -d #{c['database']} noovis2-staging.dump`
      end
    end

    desc 'Backups up heroku database from prod and restores it locally'
    task production: :environment do
      # curl complains if file doesn't already exist
      `touch noovis2-production.dump`

      # Load the current environments database config
      c = Rails.configuration.database_configuration[Rails.env]

      puts 'Capturing backup.'

      Bundler.with_clean_env do
        # Capture new backup, delete oldest manual backup if limit reached
        `heroku pg:backups capture --app noovis2-production`

        # Download the backup to a file called noovis2-staging.dump, consider adding this file to .gitignore
        `curl -o noovis2-production.dump \`heroku pg:backups public-url --app noovis2-production\``

        puts 'Restoring.'

        # Restore
        `pg_restore --verbose --clean --no-acl --no-owner -d #{c['database']} noovis2-production.dump`
      end
    end
  end
end
