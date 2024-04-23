# frozen_string_literal: true

module JobRegistration
  module Operations
    class PrepareConfig
      include Dry::Monads[:result]

      def call(schema, config, name: nil, **opts)
        result = schema.call(config)
        return Failure(result.errors.to_h) unless result.success?

        symbolized_config = config.transform_keys(&:to_sym)
        job_name = construct_job_name(symbolized_config, name)
        Success(symbolized_config.merge(opts).merge(name: job_name))
      end

      private

      def construct_job_name(config, name)
        [config[:name], name].compact.join('.')
      end
    end
  end
end
