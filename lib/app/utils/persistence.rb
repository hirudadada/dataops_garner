# frozen_string_literal: true

require_relative 'persistence/pattern'
require_relative 'persistence/provider'
require_relative 'persistence/checker'

module Garner
  module Utils
    module Persistence
      class << self
        def each_keys
          return to_enum(:each_keys) unless block_given?

          Garnet.app.keys.grep(PATTERN) { |key| key.match(PATTERN).captures[0] }.each do |key|
            yield key.empty? ? :"persistence#{key}" : :persistence
          end
        end
      end
    end
  end
end
