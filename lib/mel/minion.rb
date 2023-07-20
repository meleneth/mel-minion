# frozen_string_literal: true

module Mel
  module Minion
    class MustBeInRailsProjectError < StandardError
    end

    class PgCryptoAlreadyEnabledError < StandardError
    end

    class MustUsePostgresError < StandardError
    end
    class Error < StandardError; end
    # Your code goes here...
  end
end

require_relative "minion/version"
require_relative "minion/file_lines"
require_relative "minion/project"
require_relative "minion/implement"
require_relative "minion/enable_rails_uuid_primary_keys"
require_relative "minion/fix_has_many"
