# frozen_string_literal: true

require_relative '../../app/import'

module Ingestion
  JOB_CONFIG_PREFIX = 'ingestion_job'

  JobSchema = Dry::Schema.Params do
    required(:name).filled(:string)
    required(:max_batches).filled(:integer)
    required(:batch_size).filled(:integer)
    required(:slice_size).filled(:integer)
    required(:batch_wait).filled(:integer)
  end

  Service.register_provider :job do
    include Import[:settings]

    start do
      ingestion_config = settings.to_h
                                 .select { |k| k.start_with? JOB_CONFIG_PREFIX }
                                 .transform_keys { |k| k.to_s.sub(/^#{JOB_CONFIG_PREFIX}_/, '') }

      ingestion_config = JobSchema.call(ingestion_config).to_h

      register(:job,
               Ingestion::Job.new(**ingestion_config))
    end
  end
end
