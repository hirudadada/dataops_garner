# frozen_string_literal: true

require_relative '../../../../services/inventory'

module Garner
  module Utils
    module Persistence
      class Validator
        include Inventory::Deps['operations.check_schema']

        def validate
          response = check_schema.call
          validate_job_log_response(response)
        end

        protected

        def validate_job_log_response(response)
          return false, "Expected an array, but got #{response.class}" unless response.is_a?(Array)

          return false, 'Response array is empty' if response.empty?

          first_element = response[0]
          unless first_element.is_a?(ROM::Struct::JobLog)
            return false, "Expected the first element to be of type ROM::Struct::JobLog, but got #{first_element.class}"
          end

          [true, nil]
        end
      end
    end
  end
end
