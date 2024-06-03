# frozen_string_literal: true

module Inventory
  class Operation < Garner::Operation
    include Deps['repositories.job_logs_repo']
    include Deps['mappings.job_log_mapping']
    include Deps['mappings.job_step_log_mapping']
  end
end
