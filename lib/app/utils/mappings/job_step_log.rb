# frozen_string_literal: true

module Garner
  module Utils
    module Mappings
      module JobStepLog
        MAPPING = {
          id: :stepid,
          joblogid: :job_log_id,
          name: :step,
          status: :step_status,
          ended_at: :endtime,
          error: :errormsg,
          remark: :remark
        }.freeze
      end
    end
  end
end
