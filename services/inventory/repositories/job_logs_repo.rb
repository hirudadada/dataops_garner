# frozen_string_literal: true

module Inventory
  module Repositories
    class JobLogsRepo < Garner::Repository[:job_logs]
      def create(job_log)
        base_query.command(:create).call(job_log)
      end

      def one
        job_logs
          .limit(1)
          .combine(:job_step_logs)
          .to_a
      end

      alias check one

      def find_collectable(limit:)
        job_logs
          .collectable
          .by_started_at
          .limit(limit)
          .select_attributes
          .combine(:job_step_logs)
          .to_a
      end

      def find_by_ids(job_ids)
        base_query
          .where(joblogid: job_ids)
          .select_attributes
          .to_a
      end

      def update_as_collected(job_ids)
        job_logs.where(joblogid: job_ids).command(:update).call(collected_at: Time.now.utc)
      end

      protected

      def base_query = job_logs.combine(:job_step_logs)
    end
  end
end
