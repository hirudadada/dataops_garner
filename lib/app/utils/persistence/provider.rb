# frozen_string_literal: true

module Garner
  module Utils
    module Persistence
      class Provider
        attr_reader :key, :container

        def initialize(key = nil, container = nil)
          @key = key || 'persistence'
          @container = container || Garnet.app
        end

        def rom = container[:"#{key}.rom"]

        def persistence = container.providers[key]

        def check
          Garnet.services[:inventory]['checker']
        end
      end
    end
  end
end
