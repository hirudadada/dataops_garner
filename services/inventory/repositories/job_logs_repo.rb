# frozen_string_literal: true

module Inventory
  module Repositories
    class JobLogsRepo < Garner::Repository[:job_logs]
      include Deps['respoitories.job_step_log_repo']

      def create(job_log)
        base_query.command(:create).call(job_log)
      end
    end
  end
end
