require "securerandom"
require "fileutils"

module Mel::Minion::Implement
  class AllowHost < Base
    def self.run *args
      hostname = args.shift
      implementor = AllowHost.new hostname

      raise MustBeInRailsProjectError.new unless project.is_rails_project?

      implementor.apply_transform
      implementor.save_modified_files
    end

    attr_reader :fields
    attr_reader :name

    def initialize hostname
      super()
      @hostname = hostname
    end

    def apply_transform
      last_end_index = env_file.lines.rindex { |l| l.match "end" }
      env_file.lines.insert(last_end_index, hostname_line)
      @modified_files << env_file
    end

    def hostname_line
      "  config.hosts << \"#{@hostname}\""
    end

    def env_file
      @env_file ||= FileLines.from_file("config/environment/development.rb")
    end
  end
end
