# frozen_string_literal: true

module Inventory
  module Repositories
    class JobStepLogsRepo < Garner::Repository[:job_step_logs]
      commands :create
    end
  end
end
