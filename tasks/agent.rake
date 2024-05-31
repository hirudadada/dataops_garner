# frozen_string_literal: true

namespace :agent do
  desc 'Check connection'
  task :check do
    puts 'Checking apm agent, ping...'
    Garnet.prepare(:elastic_apm_agent)
    elastic_config = Garnet.app.providers[:elastic_apm_agent].source.config
    puts " - Enabled?: #{elastic_config.enabled}"
    puts " - Server url: #{elastic_config.url}"
    puts " - Service name: #{elastic_config.service_name}"
    puts " - CA cert?: #{elastic_config.ca_cert_file}"
    puts " - Pool size: #{elastic_config.pool_size}"
    Garnet.app['agent.check_connection'].call(url: elastic_config.url, ca_cert_file: elastic_config.ca_cert_file)
    puts 'Pong!'
  end
end
