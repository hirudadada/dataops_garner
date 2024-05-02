# frozen_string_literal: true

require 'elastic-apm'

require_relative '../../lib/utils/elastic/check_connection'
require_relative '../../lib/utils/config'

module Garner
  App.register_provider(:elastic_apm_agent) do
    include Utils::Config

    prepare do
      require 'elastic-apm'
    end

    start do
      Utils::Elastic::CheckConnection.new.call(target['settings'].apm_server_url, target['settings'].apm_server_ca_cert_file)

      server_url = target['settings'].apm_server_url
      config = {
        service_name: "#{format_for_path(target['settings'].db_host)}_#{format_for_path(target['settings'].db_name)}",
        server_url:,
        secret_token: target['settings'].apm_secret_token_encrypted.to_s.strip.empty? ? target['settings'].apm_secret_token : Schematic::Cipher.new.decrypt(target['settings'].apm_secret_token_encrypted),
        logger: target['logger']
      }

      config[:server_ca_cert_file] = target['settings'].apm_server_ca_cert_file unless target['settings'].apm_server_ca_cert_file.nil?

      agent = ElasticAPM.start(config)
      agent
    end

    stop do
      ElasticAPM.stop
    end
  end
end
