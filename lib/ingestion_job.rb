# frozen_string_literal: true

require_relative 'job_configuration_utils'

module IngestionJob
  extend JobConfigurationUtils

  Schema = Dry::Validation.Contract do
    params do
      required(:name).filled(:string)
      required(:batch_size).filled(:integer)
      required(:slice_size).filled(:integer)
      optional(:max_batches).maybe(:integer)
      optional(:batch_wait).maybe(:integer)
    end
  end
end
