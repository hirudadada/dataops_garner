# frozen_string_literal: true

require_relative 'provider'
require_relative 'providers'
require_relative 'validator'

module Garner
  module Utils
    module Persistence
      def self.start_service
        require Garnet.app.root.join('system/providers/persistence')

        Garnet.prepare(:persistence)
        Garnet.app.start(:persistence)
      end

      def self.each_persistence(&)
        Providers.new.each_persistence(&)
      end
    end
  end
end
