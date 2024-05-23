# frozen_string_literal: true

module Utils
  JOB_LOG_MAPPING = {
    id: :joblogid,
    name: :etl_procedure,
    started_at: :etl_starttime,
    ended_at: :etl_completetime,
    status_description: :etl_status_description,
    collected: :logs_collected,
    created_at: :records_insert_datetime
  }.freeze

  JOB_STEP_LOG_MAPPING = {
    id: :stepid,
    joblogid: :job_log_id,
    name: :step,
    status: :step_status,
    ended_at: :endtime,
    error: :errormsg,
    remark: :remark
  }.freeze

  module Transformations
    def self.datetime_to_iso8601(value)
      value.utc.iso8601
    end

    def self.iso8601_to_datetime(value)
      ::DateTime.parse(value)
    end

    def self.time_to_iso8601(value)
      value.utc.iso8601
    end

    def self.iso8601_to_time(value)
      ::Time.parse(value).utc
    end

    def self.time_to_datetime(value)
      value.to_datetime
    end

    def self.datetime_to_time(value)
      value.to_time
    end

    def self.to_database_job_log(value)
      # value[:started_at] = time_to_datetime(value[:started_at])
      # value[:ended_at] = time_to_datetime(value[:ended_at])
      # value[:created_at] = time_to_datetime(value[:created_at])
      value[:job_step_logs] = value[:job_step_logs].map { |step_log| to_database_job_step_log(step_log) }
      value.transform_keys! { |key| JOB_LOG_MAPPING[key] || key }
      value
    end

    def self.to_database_job_step_log(value)
      # value[:ended_at] = time_to_datetime(value[:ended_at])
      value.transform_keys! { |key| JOB_STEP_LOG_MAPPING[key] || key }
      value
    end

    def self.from_database_job_log(record)
      record.transform_keys! { |key| JOB_LOG_MAPPING.invert[key] || key }
      record.each do |key, value|
        case key
          # when :started_at, :ended_at, :created_at
          #   record[key] = datetime_to_time(value) if value.is_a?(DateTime)
        when :job_step_logs
          record[:job_step_logs] = value.map { |step_log| from_database_job_step_log(step_log) }
        end
      end
      record
    end

    def self.from_database_job_step_log(record)
      record.transform_keys { |key| JOB_STEP_LOG_MAPPING.invert[key] || key }
      # if transformed_step[:ended_at].is_a?(DateTime)
      #   transformed_step[:ended_at] = datetime_to_time(transformed_step[:ended_at])
      # end
    end
  end
end
