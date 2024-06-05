# frozen_string_literal: true

namespace :agent do
  desc 'Check connection'
  task :check do
    puts 'Checking apm agent, ping...'
    Garnet.prepare(:elastic_apm_agent)
    Garnet.prepare(:settings)
    settings = Garnet.app[:settings]
    raw_config = Garnet.app['elastic.default_options']
    puts " - Enabled?: #{settings.elastic_apm_enabled}"
    puts " - Server url: #{settings.elastic_apm_server_url}"
    puts " - Service name: #{settings.elastic_apm_service_name}"
    puts " - CA cert?: #{settings.elastic_apm_server_ca_cert_file.nil? ? 'Not Provided.' : settings.elastic_apm_server_ca_cert_file}" # rubocop:disable Layout/LineLength
    puts " - verify server cert?: #{settings.elastic_apm_verify_server_cert || raw_config[:verify_server_cert]}"
    puts " - Pool size: #{settings.elastic_apm_pool_size}"
    puts " - environment: #{settings.elastic_apm_environment || raw_config[:environment]}"
    Garnet.app['agent.check_connection'].call
    puts 'Pong!'
  end
end
