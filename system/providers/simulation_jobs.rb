# frozen_string_literal: true

require_relative '../../services/simulation/job'

module Simulation
  Service.register_provider :simulation_jobs do # rubocop:disable Metrics/BlockLength
    def job_name(config, name) = [config[:name], name].compact.join('.')

    def modify_config(config, **opts) = config.transform_keys(&:to_sym).merge(opts)

    def build_simulation_jobs(config)
      iterations = config.delete(:iterations) || 1

      Array.new(iterations) do |index|
        iteration_name = "iteration-#{index + 1}"
        config = modify_config(config, name: job_name(config, iteration_name))
        Simulation::Job.new(**config)
      end.compact
    end

    start do
      env = Garnet.app[:settings].config.app_env
      begin
        config = Garnet.app[:settings].to_h
                       .select { |k, _| k.to_s.start_with?('simulation_job') }
                       .transform_keys { |k| k.to_s.sub('simulation_job_', '').to_sym }

        if %i[test production].include?(env) || config.empty?
          register(:jobs, [].freeze)
        else
          jobs = build_simulation_jobs(service, config)
          register(:jobs, jobs.freeze)
        end
      rescue StandardError
        Garnet.app[:logger].error("Job configuration error: #{config.failure}")
        raise Garner::InvalidConfigurationError, config.failure
      end
    end
  end
end

