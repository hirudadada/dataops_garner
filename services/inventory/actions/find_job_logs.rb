# frozen_string_literal: true

module Inventory
  module Actions
    class FindJobLogs < Inventory::Action
      include Deps['actions.find_job_logs.contract']
      include Deps['operations.find_job_logs']

      def handle(params) = find_job_logs.call(job: params[:job], limit: params[:limit])
    end
  end
end
