# frozen_string_literal: true

require_relative '../schemas/ingestion_schema'
require_relative '../../services/ingestion/job'
require_relative 'operations'

module JobRegistration
  module IngestionJob
    extend Operations

    def self.register_ingestion_jobs(service) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      settings_result = create_config_from_settings(Garnet.app[:settings].to_h, 'ingestion_job')

      case settings_result
      when Dry::Monads::Result::Success
        shared_config = settings_result.value!
        persistence_keys = Garnet.app[:persistence_keys]

        jobs = persistence_keys.map do |key|
          prepare_and_create_job(Ingestion::Job, shared_config, key)
        end.compact

        service.register(:ingestion_jobs, jobs) unless jobs.empty?

      when Dry::Monads::Result::Failure
        Garnet.app[:logger].error("Ingestion Job configuration error: #{settings_result.failure}")
        raise Garner::InvalidConfigurationError, settings_result.failure
      end
    end

    def self.prepare_and_create_job(job_class, shared_config, key)
      job_config_result = prepare_config(Schemas::IngestionSchema, shared_config, name: "persistence.#{key}")

      job_config_result.or do |error_message|
        Garnet.app[:logger].error("Error preparing job configuration for key #{key}: #{error_message}")
        raise Garner::InvalidJobError, error_message
      end.bind do |job_config| # rubocop:disable Style/MultilineBlockChain
        job_class.new(**job_config)
      end
    end
  end
end
