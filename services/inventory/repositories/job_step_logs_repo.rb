# frozen_string_literal: true

module Inventory
  module Repositories
    class JobStepLogsRepo < ROM::Repository[:job_step_logs]
      commands :create

      def find_by_job_log_ids(job_log_ids)
        job_step_logs.where(job_log_id: job_log_ids).to_a
      end
    end
  end
end
