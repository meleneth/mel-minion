# frozen_string_literal: true

module Mel
  module Minion
    module Error
    end
    module Implement
    end
  end
end

require_relative "minion/error"

require_relative "minion/enable_rails_uuid_primary_keys"
require_relative "minion/file_lines"
require_relative "minion/implement/base"
require_relative "minion/implement/allow_host"
require_relative "minion/implement/rails_has_many"
require_relative "minion/implement/rails_has_one"
require_relative "minion/implement/ruby_class"
require_relative "minion/implement/tailwind"
require_relative "minion/mumble"
require_relative "minion/project"
require_relative "minion/rails_project"
require_relative "minion/version"
