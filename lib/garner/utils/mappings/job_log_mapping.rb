# frozen_string_literal: true

module Garner
  module Utils
    module Mappings
      JOB_LOG_MAPPING = {
        id: :joblogid,
        name: :etl_procedure,
        started_at: :etl_starttime,
        ended_at: :etl_completetime,
        status_description: :etl_status_description,
        created_at: :records_insert_datetime
      }.freeze
    end
  end
end
