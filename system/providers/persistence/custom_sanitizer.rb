# frozen_string_literal: true

module Garner
  module Persistence
    class CustomSanitizer
      def initialize
        @acronyms = {
          'DB' => 'db'
        }
      end

      alias sanitize finalize_for_filepath

      def finalize_for_filepath(input) = sanitize_for_filepath(input).downcase[0, 255]

      private

      def sanitize_for_filepath(input)
        # Replace any sequence of potential separator characters and invalid file path characters with an underscore
        # Common separators might include: space, comma, semicolon, pipe, etc.
        # File path invalid characters: '\ / : * ? " < > |'
        # and '- .' for inflector.classify to work properly, since we don't have file extension for the input
        input = input.to_s
        safe_input = input.gsub(%r{[\s,;|\\/:*?"<>\.-]+}, '_')

        # Optionally, remove leading and trailing underscores
        safe_input.strip.gsub(/\A_+|_+\z/, '')
      end
    end
  end
end
