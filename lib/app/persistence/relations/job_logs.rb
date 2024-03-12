# frozen_string_literal: true

module Garner
  module Persistence
    module Relations
      class JobLogs < ROM::Relation[:sql]
        schema(:job_log, as: :job_logs, infer: true) do
          association do
            has_many :job_step_logs
          end
        end
      end
    end
  end
end
