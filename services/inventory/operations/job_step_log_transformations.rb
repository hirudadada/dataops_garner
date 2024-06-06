# frozen_string_literal: true

module Inventory
  module Operations
    class JobStepLogTransformations < Inventory::Operation
      def to_database_job_step_log(value)
        value.transform_keys! { |key| job_step_log_mapping[key] || key }
      end

      def from_database_job_step_log(record)
        record.transform_keys! { |key| job_step_log_mapping.invert[key] || key }
      end
    end
  end
end
