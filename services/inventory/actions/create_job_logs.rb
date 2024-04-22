# frozen_string_literal: true

module Inventory
  module Actions
    class CreateJobLogs < Inventory::Action
      include Deps['actions.create_job_logs.contract']
      include Deps['operations.create_job_logs']

      def handle(params) = create_job_logs.call(job: params[:job], job_logs: params[:job_logs])
    end
  end
end
