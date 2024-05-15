# frozen_string_literal: true

module Inventory
  module Operations
    class CreateJobLogs < Inventory::Operation
      include Deps['transformations']
      include Garnet::Utils::PrettyPrint

      def call(job_logs)
        Sync do
          job_logs_repo.transaction do
            job_logs.each do |job_log|
              job_logs_repo.create(map_attributes(job_log))
            end
          end
        end
      end

      protected

      def add_timestamps(job_log)
        # job_log[:collected] = nil
        job_log[:created_at] = Time.now.utc
      end

      def map_attributes(job_log)
        add_timestamps(job_log)
        transformations.to_database_job_log(job_log)
      end
    end
  end
end
