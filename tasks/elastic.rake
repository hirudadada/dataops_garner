# frozen_string_literal: true

require_relative '../lib/utils/elastic/check_connection'

namespace :elastic do
  desc "Check connection"
  task :check_connection do
    url = ENV['APM_SERVER_URL']
    ca_cert_file = ENV.fetch('APM_SERVER_CA_CERT_FILE',nil)
    Utils::Elastic::CheckConnection.new.call(url, ca_cert_file)
  end
end
