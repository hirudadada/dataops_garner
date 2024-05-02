# frozen_string_literal: true

module Garner
  module Persistence
    module Relations
      class JobStepLogs < ROM::Relation[:sql]
        schema(:job_step_logs, infer: false) do
          attribute :stepid, Types::Integer.meta(primary_key: true), as: :id
          attribute :joblogid, Types::Integer, as: :job_log_id
          attribute :step, Types::String, as: :name
          attribute :step_status, Types::String, as: :status
          attribute :endtime, Types::Time, as: :ended_at
          attribute :updatedrecordcount, Types::Integer, as: :updated_record_count
          attribute :errormsg, Types::String, as: :error
          attribute :remark, Types::String.optional, as: :remark

          associations do
            belongs_to :job_logs, foreign_key: :joblogid, view: :job_logs
          end
        end

        dataset do
          from(Sequel[:DW_ETL_LOG][:Job_Details_Log])
        end
      end
    end
  end
end
