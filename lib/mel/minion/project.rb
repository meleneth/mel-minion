# frozen_string_literal: true

require "securerandom"

module Mel::Minion
  class Project
    def initialize
      find_root_dir
    end

    def is_ruby_project?
      return true if File.exist? File.join(@root_directory, "Gemfile")
      false
    end

    def is_node_project?
      return true if File.exist? File.join(@root_directory, "package.json")
      false
    end

    def is_python_project?
      return true if File.exist? File.join(@root_directory, "setup.py")
      false
    end

    def is_rails_project?
      if is_ruby_project?
        gemfile_includes_gem "rails"
      end
      false
    end

    def is_rack_project?
      return true if File.exist? File.join(@root_directory, "config.ru")
      false
    end

    def in_project_root &block
      Dir.chdir @root_directory, &block
    end

    def has_lib_dir?
      Dir.exist? File.join(@root_directory, "lib")
    end

    private

    def find_root_dir
      @root_directory = Dir.pwd
      until is_root_dir?
        @root_directory = File.expand_path "..", @root_directory
      end
    end

    def gemfile_includes_gem
    end

    def is_root_dir?
      return true if is_ruby_project?
      return true if is_rack_project?
      false
    end
  end
end
