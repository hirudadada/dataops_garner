# frozen_string_literal: true

require_relative '../../lib/garner/utils/agent'
require_relative '../../lib/garner/utils/config'
require_relative '../../lib/garner/provider_sources'

module Garner
  App.register('agent.check_connection', Utils::Agent::CheckConnection.new)
  App.register_provider(:elastic_apm_agent, source: :elastic_apm_agent, from: :app) do
    def service_name # rubocop:disable Metrics/AbcSize
      formatter = Utils::Config::ServiceNameFormatter.new

      if target[:settings].service_name.nil?
        "#{formatter.call(target[:settings].db_host)}-#{formatter.call(target[:settings].db_name)}"
      else
        formatter.call(target[:settings].service_name)
      end
    end

    config.enabled = target[:settings].elastic_apm_enabled
    config.service_name = service_name
    config.url = target[:settings].elastic_apm_server_url
    config.secret_token = target[:settings].elastic_apm_secret_token
    config.secret_token_encrypted = target[:settings].elastic_apm_secret_token_encrypted
    config.ca_cert_file = target[:settings].elastic_apm_server_ca_cert_file
    config.pool_size = target[:settings].elastic_apm_pool_size
  end
end
