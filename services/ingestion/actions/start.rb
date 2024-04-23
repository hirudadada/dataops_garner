# frozen_string_literal: true

module Ingestion
  module Actions
    class Start < Ingestion::Action
      include Deps['ingestion_jobs']
      include Deps['messages.run_next_message']

      def handle(_params)
        ingestion_jobs.each { |job| start_job(job) }
      end

      def start_job(job)
        run_next_message.deliver!(job:)
        logger.info "Scheduled ingestion job #{job.name}"
      end
    end
  end
end
