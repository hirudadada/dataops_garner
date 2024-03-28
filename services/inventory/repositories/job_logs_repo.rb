# frozen_string_literal: true

module Inventory
  module Repositories
    class JobLogsRepo < Garner::Repository[:job_logs]
      include Deps['repositories.job_step_logs_repo']

      def create(job_log)
        base_query.command(:create).call(job_log)
      end

      def base_query = job_logs.combine(:job_step_logs)
    end
  end
end
