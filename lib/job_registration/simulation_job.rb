# frozen_string_literal: true

require_relative '../schemas/simulation_schema'
require_relative '../../services/simulation/job'
require_relative 'operations'

module JobRegistration
  module SimulationJob
    extend Operations

    def self.register_simulation_jobs(service) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      env = Garnet.app[:settings].config.app_env
      config_result = create_config_from_settings(Garnet.app[:settings].to_h, 'simulation_job')

      case config_result
      when Dry::Monads::Result::Success
        shared_config = config_result.value!
        if %i[test production].include?(env) || shared_config.empty?
          service.register(:simulation_jobs, [].freeze)
        else
          jobs = build_simulation_jobs(service, shared_config)
          service.register(:simulation_jobs, jobs.freeze)
        end
      when Dry::Monads::Result::Failure
        Garnet.app[:logger].error("Job configuration error: #{config_result.failure}")
        raise Garner::InvalidConfigurationError, config_result.failure
      end
    end

    def self.build_simulation_jobs(service, shared_config)
      persistence_keys = Garnet.app[:persistence_keys]

      persistence_keys.flat_map do |key|
        build_jobs_for_key(service, shared_config.dup, key)
      end
    end

    def self.build_jobs_for_key(service, config, key) # rubocop:disable Metrics/MethodLength
      iterations = config.delete(:iterations) || 1

      Array.new(iterations) do |index|
        iteration_name = "persistence.#{key}.iteration-#{index + 1}"
        job_config_result = prepare_config(Schemas::SimulationSchema, config, name: iteration_name)

        job_config_result.or do |error_message|
          SharedUtils.log_error(service, "Error preparing job configuration for #{iteration_name}: #{error_message}")
          raise Garner::InvalidJobError, error_message
        end.bind do |job_config| # rubocop:disable Style/MultilineBlockChain
          Simulation::Job.new(**job_config)
        end
      end.compact
    end
  end
end
