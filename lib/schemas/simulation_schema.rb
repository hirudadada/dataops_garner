# frozen_string_literal: true

module Schemas
  SimulationSchema = Dry::Validation.Contract do
    params do
      optional(:name).maybe(:string)
      optional(:steps).maybe(:integer)
      optional(:max_step_duration).maybe(:integer)
      optional(:error_rate).maybe(:float)
      optional(:batch_size).maybe(:integer)
      optional(:batch_wait).maybe(:integer)
      optional(:max_batches).maybe(:float)
      optional(:batches).maybe(:integer)
      optional(:iterations).maybe(:integer)
    end
  end
end
