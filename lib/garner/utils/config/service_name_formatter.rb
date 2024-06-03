# frozen_string_literal: true

module Garner
  module Utils
    module Config
      class ServiceNameFormatter
        def call(input)
          sanitize_service_name(input)
        end

        protected

        def sanitize_service_name(str)
          # Replace any character that is not alphanumeric, an underscore, or a dash with an underscore
          sanitized_str = str.gsub(/[^a-zA-Z0-9_-]/, '_')
          # Replace dots specifically with underscores
          sanitized_str = sanitized_str.gsub('.', '_')
          # Remove leading or trailing underscores or dashes
          sanitized_str.gsub(/\A[_-]+|[_-]+\z/, '')
        end
      end
    end
  end
end
