# frozen_string_literal: true

module Mel::Minion
  class FileLines
    attr_accessor :lines
    def initialize lines = []
      @lines = lines
    end

    def as_file
      @lines.join "\n"
    end
  end
end
