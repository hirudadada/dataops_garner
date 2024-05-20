# frozen_string_literal: true

require_relative '../../lib/utils/config'
require_relative '../../lib/app/provider_sources/elastic_apm_agent'

module Garner
  App.register_provider(:elastic_apm_agent, source: :elastic_apm_agent, from: :app) do
    config.enabled = target[:settings].elastic_apm_enabled
    config.service_name = target[:settings].elastic_apm_service_name.nil? ? Utils::Config.format_for_path(target[:settings].db_host) : target[:settings].elastic_apm_service_name # rubocop:disable Layout/LineLength
    config.url = target[:settings].elastic_apm_server_url
    config.secret_token = target[:settings].elastic_apm_secret_token
    config.secret_token_encrypted = target[:settings].elastic_apm_secret_token_encrypted
    config.ca_cert_file = target[:settings].elastic_apm_server_ca_cert_file
    config.pool_size = target[:settings].elastic_apm_pool_size
  end
end
