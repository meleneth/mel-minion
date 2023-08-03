require 'set'

module Mel::Minion::Implement
  class Base
    def initialize
      @modified_files = Set.new
    end

    def apply_transform
    end

    def save_modified_files
      @modified_files.each do |f|
        f.save
      end
    end

    def project
      @project ||= init_project
    end

    def init_project
      Mel::Minion::Project.new
    end
  end
end
