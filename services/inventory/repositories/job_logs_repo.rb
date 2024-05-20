# frozen_string_literal: true

module Inventory
  module Repositories
    class JobLogsRepo < Garner::Repository[:job_logs]
      commands :create, update: :by_pk
      # def inspect
      #   # Get the relation registry from the container
      #   relation_registry = container.relations
      #
      #   # Iterate over each registered relation
      #   relation_registry.each do |relation_name, relation|
      #     puts "Relation: #{relation_name}"
      #
      #     # Get the struct class for the relation
      #     struct_class = relation.struct_class
      #
      #     # Print the struct details
      #     puts "Struct Class: #{struct_class}"
      #     puts "-------"
      #   end
      # end

      def create(job_log)
        base_query.command(:create).call(job_log)
      end

      def find_collectable(limit:)
        job_logs
          .collectable
          .by_started_at
          .limit(limit)
          .combine(:job_step_logs)
          .to_a
      end

      # job_logs
      # .where(collected_at: false)
      # .exclude(etl_completetime: nil)
      # .order {:etl_starttime}
      # .limit(limit)
      # .combine(:job_step_logs)
      # .to_a
      # end

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
        base_query
          .where(joblogid: job_ids)
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
