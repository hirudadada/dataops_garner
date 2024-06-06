# frozen_string_literal: true

require_relative '../../../services/ingestion/job'

module Ingestion
  Service.register :job do
    config = Garnet.app['settings']

    # Extra null check to apply for settings,
    # such as when the environment variable `INGESTION_JOB_MAX_BATCHES` is nil.
    max_batches = config.ingestion_job_max_batches || Float::INFINITY

    Job.new(
      name: config.ingestion_job_name,
      batch_size: config.ingestion_job_batch_size,
      slice_size: config.ingestion_job_slice_size,
      max_batches:,
      batch_wait: config.ingestion_job_batch_wait
    )
  rescue StandardError => e
    Garnet.app[:logger].error("Job configuration error: #{e.message}")
    raise Garner::InvalidConfigurationError, cause: e
  end
end
