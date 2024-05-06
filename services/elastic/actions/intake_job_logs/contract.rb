# frozen_string_literal: true

module Elastic
  module Actions
    class IntakeJobLogs
      class Contract < Garnet::Contract
        schema do
          required(:slice).filled(:string)
          required(:job_logs).array(:hash) do
            required(:id).filled(:integer)
            required(:name).filled(:string)
            required(:started_at).filled(:time)
            required(:ended_at).filled(:time)
            required(:job_step_logs).array(:hash) do
              required(:name).filled(:string)
              required(:started_at).filled(:time)
              required(:ended_at).filled(:time)
              # This could be error from the db layer
              optional(:error).maybe(:string)
            end
          end
        end
      end
    end
  end
end
