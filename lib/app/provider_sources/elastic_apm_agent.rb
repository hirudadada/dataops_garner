# frozen_string_literal: true

require_relative '../types'

module Garner
  module ProviderSources
    module ElasticApmAgent
      class Source < Dry::System::Provider::Source
        setting :enabled, constructor: Types::Params::Bool.default(true)
        setting :service_name, constructor: Types::String.constrained(filled: true)
        setting :url, constructor: Types::String.constrained(filled: true)
        setting :secret_token, constructor: Types::Coercible::StringOrNil.optional
        setting :secret_token_encrypted, constructor: Types::Coercible::StringOrNil.optional
        setting :ca_cert_file, constructor: Types::String.optional
        setting :pool_size, constructor: Types::Integer.constrained(filled: true)

        def verify_server_cert = !config.ca_cert_file.nil?

        def decrypted = Garnet::Utils::Cipher.new.decrypt(config.secret_token_encrypted)

        def elastic_config # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
          {
            enabled: config.enabled,
            service_name: config.service_name,
            server_url: config.url,
            secret_token: config.secret_token_encrypted.nil? ? config.secret_token : decrypted,
            server_ca_cert_file: config.ca_cert_file,
            verify_server_cert:,
            pool_size: config.pool_size,
            log_level: target[:settings].log_level,
            logger: target[:logger],
            hostname: target[:settings].app_name,
            environment: target[:settings].app_env
          }
        end

        def prepare
          require 'elastic-apm'

          register('elastic.config', elastic_config)
        end

        def start
          elastic_config = target['elastic.config']
          target['agent.check_connection'].call(url: elastic_config[:server_url],
                                                ca_cert_file: elastic_config[:server_ca_cert_file])
          ElasticAPM.start(elastic_config)
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
