# frozen_string_literal: true

module Inventory
  module Repositories
    class JobLogsRepo < ROM::Repository[:job_logs]
      include Deps['repositories.job_step_logs_repo']

      def create(job_log)
        base_query.command(:create).call(job_log)
      end

      def find_collectable(limit:)
        job_logs
          .where(collected: false)
          .exclude(ended_at: nil)
          .order { started_at.asc }
          .limit(limit)
          .combine(:job_step_logs) # Include job_step_logs in
          .to_a
      end

      def find_collectable_job_logs(limit:)
        job_logs
          .where(collected: false)
          .exclude(ended_at: nil)
          .order { started_at.asc }
          .limit(limit)
          .to_a
      end

      # def find_collectable_with_step_logs(limit:)
      #   collectable_job_logs = find_collectable(limit: limit)
      #   job_ids = collectable_job_logs.map(&:id)
      #   job_step_logs = job_step_logs_repo.find_by_job_log_ids(job_ids)
      #
      #   collectable_job_logs.map do |job_log|
      #     job_log_step_logs = job_step_logs.select { |step_log| step_log.job_log_id == job_log.id }
      #     job_log_hash = job_log.to_hash
      #     job_log_hash[:job_step_logs] = job_log_step_logs
      #     job_log_hash
      #   end
      # end
      #
      def find_by_ids(job_ids)
        base_query.where(id: job_ids).to_a
      end

      def update_as_collected(job_ids)
        job_logs.where(id: job_ids).command(:update).call(collected: true)
      end

      protected

      def base_query = job_logs.combine(:job_step_logs)
    end
  end
end
