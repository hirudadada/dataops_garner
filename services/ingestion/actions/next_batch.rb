# frozen_string_literal: true

module Ingestion
  module Actions
    class NextBatch < Ingestion::Action
      include Deps['messages.fetch_job_logs_message'] # callback: handle_fetched_job_logs
      # def handle(_params) = schedule_next_batch

      attr_accessor :job

      def handle(**opts)
        @job = opts[:job]
      end

      protected

      def schedule_next_batch
        job.next_batch
        if job.max_batches_reached?
          logger.info "[Job##{job.name}] Ingestion job is completed"
        else
          fetch_job_logs_message.deliver!(job:, limit: job.batch_size)
          logger.info "[Batch##{job.batch_name}] Scheduled next batch for ingestion job"
        end
      end
    end
  end
end
