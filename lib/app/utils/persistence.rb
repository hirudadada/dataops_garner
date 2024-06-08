# frozen_string_literal: true

require_relative 'persistence/start_service'
require_relative 'persistence/pattern'
require_relative 'persistence/each_persistence'
require_relative 'persistence/provider'
require_relative 'persistence/validator'

module Garner
  module Utils
    module Persistence
      def start_service
        Persistence.start_service
      end
    end
  end
end
