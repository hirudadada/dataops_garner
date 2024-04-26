# frozen_string_literal: true

module Inventory
  module Operations
    class FindJobLogs < Inventory::Operation
      def call(limit)
        Sync do
          job_logs_repo.find_collectable(limit:)
        end
      end
    end
  end
end
