# frozen_string_literal: true

module Garner
  module Utils
    module Agent
      class CheckConnection
        attr_reader :options

        def initialize(opts = {})
          @options = opts
          yield @options if block_given?
          on_init
          set_default_options
        end

        def on_init
          @options[:url] = ENV.fetch('ELASTIC_APM_SERVER_URL', nil)
          @options[:ca_cert_file] = ENV.fetch('ELASTIC_APM_CA_CERT_FILE', nil)
        end

        def default_options
          @default_options ||= {
            timeout: default_timeout,
            verify_mode: default_ssl_verify_mode
          }
        end

        def call
          uri = URI(options[:url])
          http = Net::HTTP.new(uri.host, uri.port)

          if uri.scheme == 'https'
            enable_https(uri, http, options[:ca_cert_file])
          elsif uri.scheme == 'http'
            check_https_only(uri)
          end

          response = make_http_request(uri, http)
          check_response_code(response, options[:url])
        end

        protected

        def set_default_options
          @options = default_options.merge(@options)
        end

        def default_timeout
          ENV.fetch('TIMEOUT', 5).to_i
        end

        def default_ssl_verify_mode
          case ENV.fetch('SSL_VERIFY_MODE', nil)
          when 'VERIFY_PEER'
            OpenSSL::SSL::VERIFY_PEER
          when 'VERIFY_NONE'
            OpenSSL::SSL::VERIFY_NONE
          else
            OpenSSL::SSL::VERIFY_NONE # Default to VERIFY_NONE if not set or unknown value
          end
        end

        # Method to determine SSL verification mode based on environment variable
        def enable_https(_uri, http, ca_cert_file)
          http.use_ssl = true
          http.verify_mode = options[:verify_mode]

          if ca_cert_file && File.exist?(ca_cert_file)
            http.ca_file = ca_cert_file
          elsif ca_cert_file
            raise "CA certificate file not found at: #{ca_cert_file}"
          end
          # If `ca_cert_file` is nil, no CA file is set and system defaults are used
        end

        def check_https_only(uri) # rubocop:disable Metrics/MethodLength
          https_uri = uri.dup
          https_uri.scheme = 'https'

          http = Net::HTTP.new(https_uri.host, https_uri.port)
          enable_https(https_uri, http, nil)

          # Set timeouts
          http.open_timeout = options[:timeout]
          http.read_timeout = options[:timeout]

          request = Net::HTTP::Get.new(https_uri)
          response = http.request(request)

          if response.code == '200'
            raise "Elastic APM server only allows HTTPS connections. Please use the HTTPS URL: #{https_uri}"
          end
        rescue SocketError, OpenSSL::SSL::SSLError, Net::OpenTimeout, Net::ReadTimeout
          # If an exception is raised, it means the HTTPS connection failed,
          # so we can proceed with the HTTP connection
        end

        def make_http_request(uri, http)
          request = Net::HTTP::Get.new(uri)
          http.request(request)
        end

        def check_response_code(response, url)
          raise "Elastic APM server is not reachable. Please check the server URL: #{url}" unless response.code == '200'

          puts 'Elastic APM server is reachable.'
          true
        end
      end
    end
  end
end
