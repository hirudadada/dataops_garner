# frozen_string_literal: true

require 'elastic-apm'

require_relative '../../lib/utils/elastic/check_connection'
require_relative '../../lib/utils/config'

module Utils::Config
  def password(encrypted=nil, pure=nil)
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

module Garner
  App.register_provider(:elastic_apm_agent) do
    include Utils::Config

    prepare do
      require 'elastic-apm'
    end

    start do
      Utils::Elastic::CheckConnection.new.call(target['settings'].apm_server_url, target['settings'].apm_server_ca_cert_file)

      config = {
        logger: target['logger'],
        enabled: target['settings'].apm_enabled,
        server_url: target['settings'].apm_server_url,
        hostname: target['settings'].app_name,
        secret_token: password(target['settings'].apm_secret_token_encrypted, target['settings'].apm_secret_token),
        service_name: "#{format_for_path(target['settings'].db_host)}_#{format_for_path(target['settings'].db_name)}",
        environment: target['settings'].app_env,
        log_level: target['settings'].log_level,
        pool_size: target['settings'].apm_pool_size,
      }

      config[:server_ca_cert_file] = target['settings'].apm_server_ca_cert_file unless target['settings'].apm_server_ca_cert_file.nil?

      ElasticAPM.start(config)
    end

    stop do
      ElasticAPM.stop
    end
  end
end
