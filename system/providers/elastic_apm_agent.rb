# frozen_string_literal: true

require 'elastic-apm'

require_relative '../../lib/elastic_apm_agent'

module Garner
  App.register_provider(:elastic_apm_agent) do
    include ElasticApmAgent

    prepare do
      require 'elastic-apm'
    end

    start do
      config = {
        service_name: target['settings'].service_name,
        server_url: target['settings'].apm_server_url,
        secret_token: target['settings'].apm_secret_token,
        logger: target['logger'],
        filter_exception_types: ['Elastic::CustomError']
      }

      agent = ElasticAPM.start(config)
      check_connection(target['settings'].apm_server_url) || check_connection(ENV['ELASTIC_APM_SERVER_URL']) # rubocop:disable Style/FetchEnvVar
      agent
    end

    stop do
      ElasticAPM.stop
    end
  end
end
