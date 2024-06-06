# frozen_string_literal: true

require_relative '../../../lib/app/utils/mappings'

module Inventory
  Service.register('mappings.job_log_mapping', Garner::Utils::Mappings::JobLog::MAPPING)
  Service.register('mappings.job_step_log_mapping', Garner::Utils::Mappings::JobStepLog::MAPPING)
end
