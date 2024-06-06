# frozen_string_literal: true

require_relative '../../lib/app/provider_sources'

module Garner
  App.register_provider(:elastic_apm_agent, source: :elastic_apm_agent, from: :app) do
    config.secret_token = target[:settings].elastic_apm_secret_token
    config.secret_token_encrypted = target[:settings].elastic_apm_secret_token_encrypted
    config.ca_cert_file = target[:settings].elastic_apm_server_ca_cert_file
    config.log_level = target[:settings].log_level
    config.environment = target[:settings].elastic_apm_environment || target[:settings].app_env.to_s
  end
end
