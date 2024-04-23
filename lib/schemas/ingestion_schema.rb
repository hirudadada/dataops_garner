# frozen_string_literal: true

module Schemas
  IngestionSchema = Dry::Validation.Contract do
    params do
      required(:name).filled(:string)
      optional(:batch_size).maybe(:integer)
      optional(:slice_size).maybe(:integer)
      optional(:max_batches).maybe(:float)
      optional(:batch_wait).maybe(:integer)
    end
  end
end
