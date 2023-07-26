require "securerandom"

module Mel::Minion

  class EnableRailsUUIDPrimaryKeys
    def self.run
      project = Mel::Minion::Project.new

      raise MustBeInRailsProjectError.new unless project.is_rails_project?
      raise MustUsePostgresError.new unless project.uses_postgres?
      raise PgCryptoAlreadyEnabledError.new if already_has_pgcrypto_enabled?
      create_migration("rails_enable_pgcrypto")
      generate_initializer

      puts "Migration and initializer files created successfully!"
    end

    def self.already_has_pgcrypto_enabled?
      all_migrations.any? do |migration|
        migration.match pgcrypto_regex
      end
    end

    def self.all_migrations
      Mel::Minion::FileLines.from_glob("db/migrate/*.rb")
    end

    # Get the timestamp in the format YYYYMMDDHHMMSS
    class << self
      private

      def timestamp
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def pgcrypto_regex
        Regexp.new("enable_extension 'pgcrypto'")
      end

      # Generate the filename for the migration
      def generate_filename(prefix)
        timestamp
      end

      # Create a new migration file with the given name
      def create_migration(name)
        filename = "#{generate_filename(name)}_enable_pgcrypto.rb"
        FileUtils.mkdir_p "db/migrate"
        File.write("db/migrate/#{filename}", <<~MIGRATION)
          class EnablePgcrypto < ActiveRecord::Migration[6.0]
            def change
              enable_extension 'pgcrypto'
            end
          end
        MIGRATION
      end

      # Generate the initializer to configure ActiveRecord to use UUID columns by default
      def generate_initializer
        initializer_file = "config/initializers/active_record_uuid.rb"
        if !File.exist?(initializer_file)
          File.write(initializer_file, <<~INITIALIZER)
            Rails.application.config.generators do |g|
              g.orm :active_record, primary_key_type: :uuid
            end
          INITIALIZER
        end
      end
    end
  end
end
