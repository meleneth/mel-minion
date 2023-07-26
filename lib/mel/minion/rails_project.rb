# frozen_string_literal: true

module Mel::Minion
  class RailsProject
    def models
      @models ||= Mel::Minion::FileLines.from_glob("app/models/*.rb")
    end

    def belongs_to
      @belongs_to ||= get_belongs_to
    end

    def get_belongs_to
      belongs = {}
      models.each do |model|
        key = model.bare_filename.to_sym
        belongs[key] ||= {}
        matches = model.match(/belongs_to :(.*)/)
        matches.each do |line|
          if /belongs_to :(.*)/ =~ line
            belongs[key][$1.to_sym] = true
          end
        end
      end
      belongs
    end
  end
end
