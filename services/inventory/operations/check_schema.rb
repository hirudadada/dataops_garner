# frozen_string_literal: true

module Inventory
  module Operations
    class CheckSchema < Inventory::Operation
      include Garnet::Utils::PrettyPrint

      def call
        job_log = job_logs_repo.one
        logger.debug "Check schema with job_log: #{job_log}"
        job_log
      end
    end
  end
end
