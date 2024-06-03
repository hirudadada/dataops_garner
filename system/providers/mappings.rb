# frozen_string_literal: true

require_relative '../../lib/garner/utils/mappings'

module Inventory
  Service.register('mappings.job_log_mapping', Garner::Utils::Mappings::JOB_LOG_MAPPING)
  Service.register('mappings.job_step_log_mapping', Garner::Utils::Mappings::JOB_STEP_LOG_MAPPING)
end
