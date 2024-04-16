# frozen_string_literal: true

module Garner
  module Persistence
    DB_PREFIX = 'DB'
    DB_SEPERATOR = '__' # don't use '-' as it's not a valid character in environment variable names
  end
end
