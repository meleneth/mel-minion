require "securerandom"
require "fileutils"

module Mel::Minion
  class Implement
    def self.run *args
      name = args.shift
      fields = args
      implementor = Implement.new name, fields

      if !implementor.project.is_ruby_project?
        puts "This script must be run from the root directory of a Ruby application."
        exit
      end

      puts "#{name} - args was: #{args}"
      puts implementor.file_name
      puts implementor.ruby_class
      puts implementor.spec_file_name
      puts implementor.spec_file

      implementor.project.in_project_root do
        implementor.mk_class_directory
        implementor.mk_spec_directory
        File.write(implementor.file_name, implementor.ruby_class)
        File.write(implementor.spec_file_name, implementor.spec_file)
      end

      # create_migration("RailsEnablePgCrypto")
      # generate_initializer

      # puts "Migration and initializer files created successfully!"
    end

    attr_reader :fields
    attr_reader :name

    def project
      @project ||= Project.new
    end

    def initialize name, fields = []
      @name = name
      @fields = fields
    end

    def mk_class_directory
      FileUtils.mkdir_p File.dirname(file_name)
    end

    def mk_spec_directory
      FileUtils.mkdir_p File.dirname(spec_file_name)
    end

    def module_name
      pieces[0..-2].join "::"
    end

    def class_name
      pieces[-1]
    end

    def has_module?
      module_name != ""
    end

    def file_name
      file_pieces = []
      file_pieces << "lib" if project.has_lib_dir?
      pieces.each do |p|
        file_pieces << p.downcase
      end
      "#{File.join file_pieces}.rb"
    end

    def spec_file_name
      file_pieces = ["spec"]
      pieces.each do |p|
        file_pieces << p.downcase
      end
      file_pieces[-1] = "#{file_pieces[-1]}_spec.rb"
      File.join file_pieces
    end

    def pieces
      @name.split("::")
    end

    def ruby_class
      lines = FileLines.new [
        "# frozen_string_literal: true",
        ""
      ]
      if has_module?
        lines.lines << "module #{module_name}"
        lines.lines << "  class #{class_name}"
        fields.each do |field|
          lines.lines << "    def #{field}"
          lines.lines << "    end"
        end
        lines.lines << "  end"
      else
        lines.lines << "class #{class_name}"
      end
      lines.lines << "end"
      lines.lines << ""
      lines.as_file
    end

    def spec_file
      lines = FileLines.new [
        "# frozen_string_literal: true",
        "",
        "Rspec.describe #{@name} do",
        "  let(:subject) { #{@name}.new }"
      ]
      fields.each do |field|
        lines.lines << "  describe \"##{field}\" do"
        lines.lines << "    expect(subject.#{field}).to eq(false)"
        lines.lines << "  end"
      end
      lines.lines << "end"
      lines.lines << ""
    end
  end
end
