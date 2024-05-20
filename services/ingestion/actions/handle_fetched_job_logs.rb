# frozen_string_literal: true

module Ingestion
  module Actions
    class HandleFetchedJobLogs < Ingestion::Action
      include Deps['messages.submit_to_elastic_message']

      def handle(params)
        result = params[:result]

        result.fmap { |job_logs| handle_fetched_jobs(job_logs) }.or { |error| handle_error(error) }
      end

      protected

      def handle_fetched_jobs(job_logs)
        if job_logs.empty?
          logger.info "Batch##{job.batch_name} Fetched no job logs"
          sleep job.batch_wait
          schedule_next_batch
          return
        end

        handle_submit(job_logs)
      end

      def handle_submit(job_logs)
        logger.info "[Batch##{job.batch_name}] Fetched #{job_logs.size} job logs"
        logger.debug "calling from #{__method__}, job_logs: #{job_logs}"
        submit_job_logs(job_logs)
      end

      def submit_job_logs(job_logs)
        slices = job_logs.each_slice(job.slice_size).to_a
        slices.each_with_index do |slice, i|
          slice_name = job.slice_name(i)
          job.fetched[slice_name] = slice
          logger.debug "slice: #{slice}"
          submit_to_elastic_message.deliver!(slice: slice_name, job_logs: slice)
        end
      end

      def handle_error(error)
        logger.info "[Batch ##{job.batch_name} failed to fetch job logs: #{pretty_exception(error)}"
        sleep job.batch_wait
        schedule_next_batch
      end
    end
  end
end
