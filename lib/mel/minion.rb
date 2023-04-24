# frozen_string_literal: true

module Mel
  module Minion
    class Error < StandardError; end
    # Your code goes here...
  end
end

require_relative "minion/version"
require_relative "minion/implement"
require_relative "minion/enable_rails_uuid_primary_keys"
