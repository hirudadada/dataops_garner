# frozen_string_literal: true

require_relative '../../../services/simulation/job'

module Simulation
  Service.register_provider ':create_jobs' do
    start do
      jobs = []
      unless Garnet.app[:env].staging?
        settings = Garnet.app[:settings]
        opts = {
          enabled: settings.simulation_job_enabled,
          name: settings.simulation_job_name,
          steps: settings.simulation_job_steps,
          max_step_duration: settings.simulation_job_max_step_duration,
          error_rate: settings.simulation_job_error_rate,
          batch_size: settings.simulation_job_batch_size,
          batch_wait: settings.simulation_job_batch_wait,
          max_batches: settings.simulation_job_max_batches
        }

        jobs = Job.create_jobs(opts, settings.simulation_job_iterations)
      end
      register(:jobs, jobs.freeze)
    end
  end
end
