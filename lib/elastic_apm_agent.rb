# frozen_string_literal: true

require 'net/http'

module ElasticApmAgent
  def check_connection(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    raise "Elastic APM server is not reachable. Please check the server URL: #{url}" unless response.code == '200'

    p 'Elastic APM server is reachable.'
    true
  end
end
