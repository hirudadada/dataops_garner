# frozen_string_literal: true

module Ingestion
  module Actions
    class Run
      class Contract < Garnet::Contract
        schema do
          required(:job)
        end
      end
    end
  end
end
