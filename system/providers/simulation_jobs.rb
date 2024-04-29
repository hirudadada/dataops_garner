# frozen_string_literal: true

require_relative '../../services/simulation/job'
require_relative '../../lib/utils/multiple_job'

module Simulation
  Service.register_provider :simulation_jobs do
    include Utils::MultipleJob

    start do
      env = Garnet.app[:settings].config.app_env
      config = Garnet.app[:settings].to_h
                     .select { |k, _| k.to_s.start_with?('simulation_job') }
                     .transform_keys { |k| k.to_s.sub('simulation_job_', '').to_sym }

      if %i[test production].include?(env) || config.empty?
        register(:jobs, [].freeze)
      else
        jobs = build_jobs(Job, config)
        register(:jobs, jobs.freeze)
      end
    rescue StandardError => e
      Garnet.app[:logger].error("Job configuration error: #{e.message}")
      raise Garner::InvalidConfigurationError, cause: e
    end
  end
end
