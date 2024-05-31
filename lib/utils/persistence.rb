# frozen_string_literal: true

module Utils
  module Persistence
    PATTERN = /^persistence([\..+]*)\.rom/

    def self.each_keys(container:)
      return to_enum(:each_keys, container:) unless block_given?

      container.keys.grep(PATTERN) { |key| key.match(PATTERN).captures[0] }.each do |key|
        yield key.empty? ? :"persistence#{key}" : :persistence
      end
    end

    class Connection
      attr_reader :key

      def initialize(key)
        @key = key || 'persistence'
      end

      def rom = Garnet.app[:"#{key}.rom"]

      def provider = Garnet.app.providers[key]

      def check
        rom.relations[:job_logs]
           .limit(1)
           .combine(:job_step_logs)
           .to_a
      end
    end
  end
end
