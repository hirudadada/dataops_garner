# frozen_string_literal: true

module Garner
  module Utils
    module Persistence
      class Validator
        def initialize(rom, container = nil)
          @repo = Inventory::Repositories::JobLogsRepo.new(rom)
          container ||= Garnet.app
          @logger = container[:logger]
        end

        def call
          response = check_schema
          validate_job_log_response(response)
        end

        protected

        def check_schema
          job_log = repo.one
          logger.debug "Check schema with job_log: #{job_log}"
          job_log
        end

        def validate_job_log_response(response)
          return false, "Expected an array, but got #{response.class}" unless response.is_a?(Array)

          return false, 'Response array is empty' if response.empty?

          first_element = response[0]
          unless first_element.is_a?(ROM::Struct::JobLog)
            return false, "Expected the first element to be of type ROM::Struct::JobLog, but got #{first_element.class}"
          end

          [true, nil]
        end

        private

        attr_reader :repo, :logger
      end
    end
  end
end
