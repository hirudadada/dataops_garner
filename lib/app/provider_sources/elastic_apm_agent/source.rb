# frozen_string_literal: true

module Garner
  module ProviderSources
    module ElasticApmAgent
      class Source < Dry::System::Provider::Source
        setting :secret_token, constructor: Garner::Types::Coercible::StringOrNil.optional
        setting :secret_token_encrypted, constructor: Garner::Types::Coercible::StringOrNil.optional
        setting :ca_cert_file, constructor: Garner::Types::String.optional
        setting :pool_size, constructor: Garner::Types::Integer.constrained(filled: true)
        setting :log_level, constructor: Garner::Types::String.optional
        setting :environment, constructor: Garner::Types::String.optional

        def verify_server_cert = !config.ca_cert_file.nil?

        def decrypted = Garnet::Utils::Cipher.new.decrypt(config.secret_token_encrypted)

        def default_options
          {
            secret_token: config.secret_token_encrypted.nil? ? config.secret_token : decrypted,
            server_ca_cert_file: config.ca_cert_file,
            verify_server_cert:,
            environment: config.environment,
            log_level: config.log_level,
            logger: target[:logger]
          }
        end

        def prepare
          require 'elastic-apm'

          register('agent.default_options', default_options)
          register('agent.check_connection', CheckConnection.new)
        end

        def start
          default_options = target['agent.default_options']
          ElasticAPM.start(default_options)
          if ElasticAPM.running?
            puts 'Elastic APM agent connected.'
          else
            puts 'Elastic APM agent failed to connect.'
          end
        end

        def stop = ElasticAPM.stop
      end
    end
  end
end

Dry::System.register_provider_source(
  :elastic_apm_agent,
  group: :app,
  source: Garner::ProviderSources::ElasticApmAgent::Source
)
