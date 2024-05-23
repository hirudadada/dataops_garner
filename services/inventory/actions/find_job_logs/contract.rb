# frozen_string_literal: true

module Inventory
  module Actions
    class FindJobLogs
      class Contract < Garnet::Contract
        schema do
          required(:limit)
        end
      end
    end
  end
end
