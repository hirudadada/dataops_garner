# frozen_string_literal: true

module Simulation
  module Actions
    class Run < Simulation::Action
      include Deps['actions.run.contract']
      include Deps['messages.save_job_logs_message']
      include Deps['messages.run_next_message']

      def handle(params)
        job = params[:job]

        job_logs = job.run
        logger.info "Rendered #{job_logs.size} job logs for #{job.name}"

        save_job_logs_message.deliver!(job:, job_logs:).fmap do |_r|
          if job.max_batches_reached?
            logger.info "Completed simulation for #{job.name}"
          else
            schedule_next_job_run(job)
          end
        end
      end

      def schedule_next_job_run(job)
        sleep job.batch_wait
        run_next_message.deliver!(job:)
        logger.info "Scheduled next job run for #{job.name}"
      end
    end
  end
end
