# frozen_string_literal: true

require_relative 'persistence/provider'

module Garner
  module Utils
    module Persistence
      PATTERN = /^persistence([\..+]*)\.rom/

      class << self
        def setup
          Garnet.prepare(:persistence)
          Garnet.app.start(:persistence)
        end

        def each_keys(container:)
          return to_enum(:each_keys, container:) unless block_given?

          container.keys.grep(PATTERN) { |key| key.match(PATTERN).captures[0] }.each do |key|
            yield key.empty? ? :"persistence#{key}" : :persistence
          end
        end

        def each_provider(container:)
          each_keys(container:) { |key| yield Provider.new(key:) }
        end
      end
    end
  end
end
