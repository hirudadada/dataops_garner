# frozen_string_literal: true

module Ingestion
  module Actions
    # Complete Slice
    class HandleUpdatedAsCollected < Ingestion::Action
      protected

      # rubocop:disable Style/MultilineBlockChain
      def handle(params) # rubocop:disable Metrics/AbcSize
        slice = params[:request][:data][:slice]
        job_logs = params[:request][:data][:job_logs]
        params[:result].fmap do |_updated_job_logs|
          logger.info "[Slice##{slice}] Updated #{job_logs.size} job logs as collected"
        end.or do |e|
          logger.info "[Slice##{slice}] Failed to update #{job_logs.size} job logs as collected: #{pretty_exception(e)}"
        end
        job.processed[slice] = job_logs
        schedule_next_batch if job.batch_completed?
      end
      # rubocop:enable Style/MultilineBlockChain
    end
  end
end
