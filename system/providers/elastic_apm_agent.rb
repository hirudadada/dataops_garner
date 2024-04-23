# frozen_string_literal: true

require 'net/http'
require 'elastic-apm'

module ElasticApmAgent
  def self.check_connection(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    raise "Elastic APM server is not reachable. Please check the server URL: #{url}" unless response.code == '200'

    p 'Elastic APM server is reachable.'
    true
  end
end

module Garner
  App.register_provider(:elastic_apm_agent) do
    prepare do
      require 'elastic-apm'
    end

    start do
      define_singleton_method(:check_connection) do |url|
        ElasticApmAgent.check_connection(url)
      end

      config = {
        service_name: target['settings'].app_name,
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
