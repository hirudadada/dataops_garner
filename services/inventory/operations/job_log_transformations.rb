# frozen_string_literal: true

module Inventory
  module Operations
    class JobLogTransformations < Inventory::Operation
      include Deps['operations.job_step_log_transformations']

      def to_database_job_log(value)
        value[:job_step_logs] = value[:job_step_logs].map do |step_log|
          job_step_log_transformations.to_database_job_step_log(step_log)
        end
        value.transform_keys! { |key| job_log_mapping[key] || key }
      end

      def from_database_job_log(record)
        record.transform_keys! { |key| job_log_mapping.invert[key] || key }
        record.each do |key, value|
          case key
          when :job_step_logs
            record[:job_step_logs] = value.map do |step_log|
              job_step_log_transformations.from_database_job_step_log(step_log)
            end
          end
        end
        record
      end
    end
  end
end
