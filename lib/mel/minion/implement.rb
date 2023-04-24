require "securerandom"

module Mel::Minion
  class Implement
    def self.run *args
      project = Project.new
      if not project.is_ruby_project?
        puts "This script must be run from the root directory of a Ruby application."
        exit
      end

      puts "args was: #{args}"

      # create_migration("RailsEnablePgCrypto")
      # generate_initializer

      # puts "Migration and initializer files created successfully!"
    end

    # Get the timestamp in the format YYYYMMDDHHMMSS
    class << self
      private

      def self.lib_dir_exist
        Dir.exist? "lib"
      end

      def self.find_project_dir
      end

      def self.timestamp
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      # Generate the filename for the migration
      def self.generate_filename(prefix)
        "#{timestamp}_#{prefix}_#{SecureRandom.hex(4)}"
      end

      # Create a new migration file with the given name
      def self.create_migration(name)
        filename = "#{generate_filename(name)}_enable_pgcrypto.rb"
        File.write("db/migrate/#{filename}", <<~MIGRATION)
          class #{name} < ActiveRecord::Migration[6.0]
            def change
              enable_extension 'pgcrypto'
            end
          end
        MIGRATION
      end

      # Generate the initializer to configure ActiveRecord to use UUID columns by default
      def self.generate_initializer
        initializer_file = "config/initializers/active_record_uuid.rb"
        if !File.exist?(initializer_file)
          File.write(initializer_file, <<~INITIALIZER)
            Rails.application.config.active_record.generators do |g|
              g.orm :active_record, primary_key_type: :uuid
            end
          INITIALIZER
        end
      end
    end
  end
end
