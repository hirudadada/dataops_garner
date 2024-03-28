# frozen_string_literal: true

module Garner
  App.register_provider(:agent) do
    prepare do
      require 'elastic-apm'
    end

    start do
      config = {
        service_name: target['settings'].app_name,
        # server_url: target['settings'].apm_server_url,
        # secret_token: target['settings'].apm_secret_token,
        logger: target['logger'],
        filter_exception_types: ['Elastic::CustomError']
      }
      register(:agent, ElasticAPM.start(config))
    end

    stop do
      ElasticAPM.stop
    end
  end
end
