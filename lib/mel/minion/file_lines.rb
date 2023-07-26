# frozen_string_literal: true

module Mel::Minion
  class FileLines
    attr_accessor :lines
    attr_reader :filename

    def self.from_glob(my_glob)
      files = []
      Dir.glob(my_glob).each do |filename|
        File.open(filename) do |fh|
          files << from_filehandle(filename: filename, handle: fh)
        end
      end
      files
    end

    def self.from_filehandle(filename:, handle:)
      FileLines.new filename: filename, lines: handle.readlines.map(&:chomp)
    end

    def initialize(filename:, lines: [])
      @lines = lines
      @filename = filename
    end

    def as_file
      @lines.join "\n"
    end

    def save
      File.write(filename, as_file)
    end

    def match(pattern)
      @lines.filter { |l| l.match pattern }
    end

    def bare_filename
      File.basename(@filename, ".rb")
    end
  end
end
