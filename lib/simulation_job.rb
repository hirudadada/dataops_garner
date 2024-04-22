# frozen_string_literal: true

module SimulationJob
  extend JobConfigurationUtils

  Schema = Dry::Validation.Contract do
    params do
      required(:name).filled(:string)
      required(:steps).filled(:integer)
      required(:max_step_duration).filled(:integer)
      required(:error_rate).filled(:float)
      required(:batch_size).filled(:integer)
      optional(:batch_wait).maybe(:integer)
      optional(:max_batches).value(:integer)
      optional(:batches).value(:integer)
      optional(:iterations).maybe(:integer)
    end
  end
end
