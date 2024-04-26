# frozen_string_literal: true

module Simulation
  module Actions
    # the start action to simulate job_logs
    class Start < Simulation::Action
      include Deps['jobs']
      include Deps['messages.run_next_message']

      protected

      def handle(_params)
        jobs.each { |job| start_job(job) }
      end

      def start_job(job)
        run_next_message.deliver!(job:)
        logger.info "Scheduled simulation job #{job.name}"
      end
    end
  end
end
