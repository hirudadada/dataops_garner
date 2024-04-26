# frozen_string_literal: true

require_relative '../../services/ingestion/job'

module Ingestion
  Service.register_provider :ingestion_jobs do
    start do
      config = Garnet.app['settings'].to_h
                     .select { |k, _| k.to_s.start_with?('ingestion_job') }
                     .transform_keys { |k| k.to_s.sub('ingestion_job_', '').to_sym }
      register(:jobs, Ingestion::Job.new(**config).freeze)
    rescue StandardError
      Garnet.app[:logger].error("Job configuration error: #{config.failure}")
      raise Garnet::InvalidConfigurationError, config.failure
    end
  end
end
