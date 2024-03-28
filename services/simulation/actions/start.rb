# frozen_string_literal: true

module Simulation
  module Actions
    # Starter Action of simulating Job logs
    class Start < Simulation::Action
      include Deps['jobs']
      include Deps['messages.run_next_message']

      def handle(_params)
        jobs.each { |job| start(job) }
      end

      def start(job)
        run_next_message.deliver!(job:)
        logger.info "Scheduled simulation job #{job.name}"
      end
    end
  end
end
