# frozen_string_literal: true

module Garner
  module Persistence
    module Relations
      class JobLogs < ROM::Relation[:sql]
        # TODO: still have to figure out usage of alias: value
        schema(:job_status_log, infer: true, as: :job_logs) do
          attribute :joblogid, Types::Integer.meta(primary_key: true, alias: :id)
          attribute :etl_procedure, Types::String.meta(alias: :name)
          # attribute :etl_parameter, Types::String.meta(alias: :parameter)
          attribute :etl_starttime, Types::Time.meta(alias: :started_at)
          attribute :etl_completetime, Types::Time.optional, as: :ended_at
          # attribute :etl_status, Types::Integer.meta(alias: :status)
          # attribute :etl_status_description, Types::String.meta(alias: :status_description)
          # attribute :etl_execute_by, Types::String.meta(alias: :executed_by)
          # attribute :etl_batch_id, Types::String.meta(alias: :batch_id)
          attribute :records_insert_datetime, Types::Time.meta(alias: :created_at)
          attribute :collected_at, Types::Time.optional

          associations do
            has_many :job_step_logs, foreign_key: :joblogid, combine_key: :joblogid, view: :for_job_status_log,
                                     override: true
          end
        end

        def collectable
          where(collected_at: nil).exclude(etl_completetime: nil)
        end

        def by_started_at
          order(:etl_starttime)
        end

        # TODO: Need to find a way to combine the data from :job_details_logs
        # def with_details
        #   relation(dataset: dataset.join(:DW_ETL_LOG__JOB_DETAILS_LOG, joblogid: :joblogid))
        # end

        dataset do
          from(Sequel.qualify(:DW_ETL_LOG, :JOB_STATUS_LOG))
        end
      end
    end
  end
end
