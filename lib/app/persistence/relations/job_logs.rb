# frozen_string_literal: true

module Garner
  module Persistence
    module Relations
      class JobLogs < ROM::Relation[:sql]
        schema(:job_logs, infer: false) do
          attribute :joblogid, Types::Integer.meta(primary_key: true), as: :id
          attribute :etl_procedure, Types::String, as: :name
          attribute :etl_parameter, Types::String, as: :parameter
          attribute :etl_starttime, Types::Time, as: :started_at
          attribute :etl_completetime, Types::Time, as: :ended_at
          attribute :etl_status, Types::Integer, as: :status
          attribute :etl_status_description, Types::String, as: :status_description
          attribute :etl_execute_by, Types::String, as: :executed_by
          attribute :etl_batch_id, Types::String, as: :batch_id
          attribute :records_insert_datetime, Types::Time, as: :created_at
          attribute :logs_collected, Types::Bool, as: :collected

          associations do
            has_many :job_step_logs, foreign_key: :joblogid
          end
        end

        dataset do
          from(Sequel[:DW_ETL_LOG][:Job_Status_Log])
        end
      end
    end
  end
end
