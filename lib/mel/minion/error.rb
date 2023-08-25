# frozen_string_literal: true

module Mel::Minion::Error
  class MustBeInVueProjectError < StandardError
  end

  class MustBeInRailsProjectError < StandardError
  end

  class PgCryptoAlreadyEnabledError < StandardError
  end

  class MustUsePostgresError < StandardError
  end

  class Error < StandardError; end
end

