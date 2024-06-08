# frozen_string_literal: true

module Garner
  module Utils
    module Persistence
      def self.each_persistence
        return to_enum(:each_keys) unless block_given?

        Garnet.app.keys.grep(PATTERN) { |key| key.match(PATTERN).captures[0] }.each do |key|
          yield key.empty? ? :"persistence#{key}" : :persistence
        end
      end
    end
  end
end
