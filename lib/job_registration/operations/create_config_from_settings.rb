# frozen_string_literal: true

module JobRegistration
  module Operations
    class CreateConfigFromSettings
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      def call(settings, config_prefix)
        valid_settings = yield validate_settings(settings)
        Success(extract_config(valid_settings, config_prefix))
      end

      private

      def validate_settings(settings)
        settings.nil? ? Failure('settings cannot be nil') : Success(settings)
      end

      def extract_config(settings, config_prefix)
        settings.select { |k, _| k.start_with?(config_prefix) }
                .transform_keys { |k| k.to_s.sub("#{config_prefix}_", '') }
      end
    end
  end
end
