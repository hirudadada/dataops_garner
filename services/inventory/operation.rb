# frozen_string_literal: true

module Inventory
  class Operation < Garner::Operation
    include Deps['repositories.job_logs_repo']
  end
end
