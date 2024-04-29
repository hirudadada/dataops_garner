# frozen_string_literal: true

module Inventory
  module Operations
    class FindJobLogs < Inventory::Operation
      include Deps['transformations']

      def call(limit)
        Sync do
          job_logs = job_logs_repo.find_collectable(limit:)
          job_logs.map { |job_log| transform_entry(job_log.to_h) }
        end
      end

      protected

      def transform_entry(job_log)
        job_log_transformed = transformations.from_database_job_log(job_log)
        transform_job_step_logs(job_log_transformed)
      end

      def transform_job_step_logs(job_log)
        first_step_log_started_at = job_log[:started_at]
        job_log[:job_step_logs] = job_log[:job_step_logs].each_with_index.with_object([]) do |(step, idx), acc|
          step = step.to_h
          step[:started_at] = acc.empty? ? first_step_log_started_at : acc[idx - 1][:ended_at]
          acc << step
        end
        job_log
      end
    end
  end
end
