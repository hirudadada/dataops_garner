# frozen_string_literal: true

require_relative '../../lib/ingestion_job'
require_relative '../../services/ingestion/job'

module Ingestion
  Service.register_provider :jobs do
    start do
      shared_config = IngestionJob.create_config_from_settings(Garnet.app[:settings].to_h, 'ingestion_job')
      persistence_keys = Garnet.app[:persistence_keys]

      jobs = persistence_keys.map do |key|
        config = IngestionJob.prepare_config(IngestionJob::Schema, shared_config, name: "persistence.#{key}")
        Job.new(**config)
      end

      register(:jobs, jobs)
    end
  end
end
