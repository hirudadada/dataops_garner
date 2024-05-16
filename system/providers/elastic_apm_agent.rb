# frozen_string_literal: true

require 'elastic-apm'

require_relative '../../lib/utils/elastic/check_connection'
require_relative '../../lib/utils/config'

module Utils
  module Config
    def password(encrypted = nil, pure = nil)
      if encrypted.to_s.strip.empty?
        pure
      else
        password_decrypted(encrypted)
      end
    end

    def password_decrypted(encrypted)
      Garnet::Utils::Cipher.new.decrypt(encrypted)
    end
  end
end

module Garner
  App.register_provider(:elastic_apm_agent) do
    include Utils::Config

    prepare do
      require 'elastic-apm'
    end

    start do
      settings = target['settings']
      Utils::Elastic::CheckConnection.new.call(settings.apm_server_url, settings.apm_server_ca_cert_file)

      config = {
        logger: target['logger'],
        enabled: settings.apm_enabled,
        server_url: settings.apm_server_url,
        hostname: settings.app_name,
        secret_token: password(settings.apm_secret_token_encrypted, settings.apm_secret_token),
        service_name: settings.service_name.to_s.strip.empty? ? "#{format_for_path(settings.db_host)}_#{format_for_path(settings.db_name)}" : settings.service_name, # rubocop:disable Layout/LineLength
        environment: settings.app_env,
        log_level: settings.log_level,
        pool_size: settings.apm_pool_size
      }

      config[:server_ca_cert_file] = settings.apm_server_ca_cert_file unless settings.apm_server_ca_cert_file.nil?

      ElasticAPM.start(config)
    end

    stop do
      ElasticAPM.stop
    end
  end
end
