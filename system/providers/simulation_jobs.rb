# frozen_string_literal: true

require_relative '../../lib/simulation_job'
require_relative '../../services/simulation/job'

module Simulation
  Service.register_provider :simulation_jobs do
    start do
      shared_config = SimulationJob.create_config_from_settings(Garnet.app[:settings].to_h, 'simulation_job')
      persistence_keys = Garnet.app[:persistence_keys]

      jobs = persistence_keys.flat_map do |key|
        config_for_key = shared_config.dup
        iterations = config_for_key.delete(:iterations) || 1

        Array.new(iterations) do |index|
          iteration_name = "persistence.#{key}.iteration-#{index + 1}"
          config = SimulationJob.prepare_config(SimulationJob::Schema, config_for_key, name: iteration_name)
          Job.new(**config)
        end
      end

      register(:jobs, jobs.freeze)
    end
  end
end
