# frozen_string_literal: true

require "securerandom"
require "json"

module Mel::Minion
  class Project
    def initialize
      find_root_dir
    end

    def file_relative_glob(my_glob)
      Dir.chdir(@root_directory) do
        return Dir.glob(my_glob)
      end
    end

    def file_relative_exists? filename
      return true if File.exist? File.join(@root_directory, filename)
      false
    end

    def file_relative_open(filename, &block)
      actual_filename = File.join(@root_directory, filename)
      puts "Opening file #{actual_filename}"
      File.open(actual_filename) do |f|
        yield f
      end
    end

    def file_relative_lines(filename)
      file_relative_open(filename) do |f|
        FileLines.from_filehandle filename: filename, handle: f
      end
    end

    def file_relative_json(filename)
      file_relative_open(filename) do |f|
        return JSON.parse f.read
      end
    end

    def is_ruby_project?
      file_relative_exists?("Gemfile")
    end

    def is_node_project?
      file_relative_exists?("package.json")
    end

    def is_vue_project?
      if is_node_project?
        return package_includes_dependency("vue")
      end
      false
    end

    def is_python_project?
      file_relative_exists?("setup.py")
    end

    def is_rails_project?
      if is_ruby_project?
        return gemfile_includes_gem? "rails"
      end
      false
    end

    def uses_postgres?
      if is_ruby_project?
        return gemfile_includes_gem? "pg"
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

    def gemfile_includes_gem?(gem)
      gemfile.match("gem \"#{gem}\"")
    end

    def package_includes_dependency(package)
      file_relative_json("package.json")["dependencies"].has_key? package
    end

    def gemfile
      file_relative_lines("Gemfile")
    end

    def is_root_dir?
      return true if is_ruby_project?
      return true if is_rack_project?
      return true if is_python_project?
      return true if is_node_project?
      false
    end
  end
end
