# frozen_string_literal: true

module Mel::Minion
  class FileLines
    attr_accessor :lines

    def self.from_glob(my_glob)
      Dir.glob(my_glob).each do |filename|
        File.open(filename) do |fh|
          from_filehandle(filename: filename, handle: fh)
        end
      end
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

    def save_file
      File.write(filename, as_file)
    end

    def match(pattern)
      @lines.any? { |l| l.match pattern }
    end
  end
end
