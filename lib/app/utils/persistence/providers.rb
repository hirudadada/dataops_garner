# frozen_string_literal: true

module Garner
  module Utils
    module Persistence
      class Providers
        PATTERN = /^persistence([.^+]*)\.rom/

        def initialize(container = nil)
          @container = container || Garnet.app
        end

        def each_persistence
          return enum_for(:each_persistence) unless block_given?

          @container.keys.grep(PATTERN) { |key| key.match(PATTERN).captures[0] }.each do |key|
            yield key.empty? ? :"persistence#{key}" : :persistence
          end
        end
      end

      private

      attr_reader :container
    end
  end
end
