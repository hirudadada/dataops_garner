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

        if uri.scheme == 'https'
          enable_https(uri, http, ca_cert_path)
        elsif uri.scheme == 'http'
          check_https_only(uri)
        end

        response = make_http_request(uri, http)
        check_response_code(response, url)
      end

      protected

      def enable_https(_uri, http, ca_cert_path)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        if ca_cert_path && File.exist?(ca_cert_path)
          http.ca_file = ca_cert_path
        elsif ca_cert_path
          raise "CA certificate file not found at: #{ca_cert_path}"
        end
        # If `ca_cert_path` is nil, no CA file is set and system defaults are used
      end

      def check_https_only(uri)
        https_uri = uri.dup
        https_uri.scheme = 'https'

        http = Net::HTTP.new(https_uri.host, https_uri.port)
        enable_https(https_uri, http, nil)

        request = Net::HTTP::Get.new(https_uri)
        response = http.request(request)

        if response.code == '200'
          raise "Elastic APM server only allows HTTPS connections. Please use the HTTPS URL: #{https_uri}"
        end
      rescue SocketError, OpenSSL::SSL::SSLError
        # If an exception is raised, it means the HTTPS connection failed,
        # so we can proceed with the HTTP connection
      end

      def make_http_request(uri, http)
        request = Net::HTTP::Get.new(uri)
        response = http.request(request)
      end

      def check_response_code(response, url)
        raise "Elastic APM server is not reachable. Please check the server URL: #{url}" unless response.code == '200'

        puts 'Elastic APM server is reachable.'
        true
      end
    end
  end
end
