# frozen_string_literal: true

module Elastic
  module Actions
    class IntakeJobLogs < Elastic::Action
      include Deps['actions.intake_job_logs.contract']
      include Deps['operations.send_apm_logs']

      def handle(params)
        slice = params[:slice]
        job_logs = params[:job_logs]
        logger.debug "calling from #{__method__}, slice, job_logs: #{slice}, #{job_logs}"
        Sync do
          send_apm_logs.call(job_logs)
          logger.info "[Slice##{slice}] Transformed #{job_logs.size} job logs to Elastic APM entries"
        end
      end
    end
  end
end
