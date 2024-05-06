# frozen_string_literal: true

module Garner
  module Persistence
    module Relations
      class JobStepLogs < ROM::Relation[:sql]
        schema(:job_details_log, infer: true, as: :job_step_logs) do
          attribute :stepid, Types::Integer.meta(primary_key: true, alas: :id)
          attribute :joblogid, Types::Integer.meta(alias: :job_log_id)
          attribute :step, Types::String.meta(alias: :name)
          attribute :step_status, Types::String.meta(alias: :status)
          attribute :endtime, Types::Time.meta(alias: :ended_at)
          # attribute :updatedrecordcount, Types::Integer.meta(alias: :updated_record_count)
          attribute :errormsg, Types::String.meta(alias: :error)
          attribute :remark, Types::String.optional

          associations do
            belongs_to :job_logs, foreign_key: :joblogid, view: :with_details, override: true, combine_key: :joblogid
          end
        end

        def for_job_status_log(_assoc, job_status_logs)
          # TODO: This combine through ram, still have to figure out how to join by qualified name
          where(joblogid: job_status_logs.map { |log| log[:joblogid] })
        end

        dataset do
          from(Sequel.qualify(:dw_etl_log, :job_details_log))
        end
      end
    end
  end
end
