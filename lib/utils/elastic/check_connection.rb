# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'openssl'

module Utils
  module Elastic
    class CheckConnection
      def call(url, ca_cert_path = nil)
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)

        if uri.scheme == "https"
          enable_https(uri, http, ca_cert_path)
        end

        response = make_http_request(uri, http)
        check_response_code(response, url)
      end

      protected

      def enable_https(uri, http, ca_cert_path)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        if ca_cert_path && File.exist?(ca_cert_path)
          http.ca_file = ca_cert_path
        elsif ca_cert_path
          raise "CA certificate file not found at: #{ca_cert_path}"
        end
        # If `ca_cert_path` is nil, no CA file is set and system defaults are used
      end

      def make_http_request(uri, http)
        request = Net::HTTP::Get.new(uri)
        response = http.request(request)
      end

      def check_response_code(response, url)
        unless response.code == '200'
          raise "Elastic APM server is not reachable. Please check the server URL: #{url}"
        end

        puts 'Elastic APM server is reachable.'
        true
      end
    end
  end
end
