require "securerandom"
require "fileutils"
require 'awesome_print'

module Mel::Minion::Implement
  class RailsHasMany
    def self.run *args
      table = args.shift
      field = args.shift
      puts "Running against: #{table} #{field}"
      project = Mel::Minion::Project.new

      if !project.is_ruby_project?
        puts "This script must be run from the root directory of a Ruby application."
        exit
      end

      implementor = RailsHasMany.new table, field
      implementor.do_transform
      puts "save the thing"
      implementor.save_files
    end

    attr_reader :table
    attr_reader :field
    attr_reader :modified_files

    def do_transform
      puts table_model
      table_model.lines[1, 0] = "  has_many :#{field}"
      modified_files << table_model
    end

    def field_sym
      ":#{@field}".to_sym
    end

    def model_filename
      "app/models/#{@table}.rb"
    end

    def table_model
      @table_model ||= project.models.find { |m| m.filename == model_filename }
      raise "No such table #{model_filename}" unless @table_model
      @table_model
    end

    def project
      @project ||= Mel::Minion::RailsProject.new
    end

    def save_files
      @modified_files.each do |f|
        f.save
      end
    end

    def initialize table, field
      @table = table
      @field = field
      @modified_files = []
    end
  end
end
