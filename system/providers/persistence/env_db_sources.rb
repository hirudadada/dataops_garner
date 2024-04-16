# frozen_string_literal: true

require_relative 'custom_sanitizer'
require_relative 'db_schema'

module Garner
  module Persistence
    class EnvDbSources
      extend Dry::Initializer

      option :guard, default: proc { CustomSanitizer.new }
      option :prefix, default: proc { ENV.fetch('DB_PREFIX', DB_PREFIX) }
      option :seperator, default: proc { ENV.fetch('DB_SEPERATOR', DB_SEPERATOR) }

      def matching = "^#{guard.sanitize(prefix)}#{seperator}([^#{seperator}]+)#{seperator}"

      def fetch # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        ENV
          .select { |key, _| key.start_with?("#{prefix}#{seperator}") }
          .transform_keys { |key| guard.sanitize(key) }
          .group_by { |key, _| key.match(/#{matching}/).captures.first }
          .each_with_object([]) do |(key, values), acc|
            transformed = values.to_h.transform_keys { |k| k.sub(/#{matching}/, '').to_sym }
            if transformed.key?(:db_service)
              transformed[:name] = guard.sanitize(transformed[:db_service])
              transformed.delete(:db_service)
            else
              transformed[:name] = key
            end
            acc << DbSchema.call(transformed).to_h
          end
      end
    end
  end
end
