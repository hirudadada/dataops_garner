# frozen_string_literal: true

require 'elastic-apm'

require_relative '../../lib/utils/elastic_apm_agent'
require_relative '../../lib/utils/config'

module Garner
  App.register_provider(:elastic_apm_agent) do
    include Utils::ElasticApmAgent
    include Utils::Config

    prepare do
      require 'elastic-apm'
    end

    start do
      secret_token = nil
      if target['settings'].apm_secret_token_encrypted.nil? || target['settings'].apm_secret_token_encrypted.empty?
        secret_token = target['settings'].apm_secret_token
      else
        secret_token = Schematic::Cipher.new.decrypt(target['settings'].apm_secret_token_encrypted)
      end

      config = {
        service_name: "#{format_for_path(target['settings'].db_host)}_#{format_for_path(target['settings'].db_name)}",
        server_url: target['settings'].apm_server_url,
        secret_token: ,
        logger: target['logger']
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
