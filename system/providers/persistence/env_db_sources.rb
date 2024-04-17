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

      def fetch # rubocop:disable Metrics/AbcSize
        ENV
          .select { |key, _| key.start_with?("#{prefix}#{seperator}") }
          .transform_keys { |key| sanitize(key) }
          .group_by { |key, _| key.match(/#{matching}/).captures.first }
          .each_with_object([]) do |(key, values), acc|
            transformed = transform_db_settings(key, values.to_h)
            acc << DbSchema.call(transformed).to_h
          end
      end

      private

      def sanitize(key) = guard.sanitize(key)

      def matching = "^#{sanitize(prefix)}#{seperator}([^#{seperator}]+)#{seperator}"

      def transform_db_settings(key, data)
        data = data.transform_keys { |k| k.to_s.sub(/#{matching}/, '').to_sym }
        if data.key?(:db_service)
          data[:name] = sanitize(data[:db_service])
          data.delete(:db_service)
        else
          data[:name] = key
        end
        data
      end
    end
  end
end
