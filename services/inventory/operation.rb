# frozen_string_literal: true

module Inventory
  class Operation < Garner::Operation
    # include Deps['repositories.job_logs_repo']
    include Deps[:repo_registry]

    attr_reader :job

    def call(**opts)
      @job = opts[:job]
    end

    def strategy = mapping[:RemovePersistencePrefix]

    def job_logs_repo
      rom_key = strategy.call(job.name)
      repo_type = :job_logs
      repo_registry.resolve(rom_key:, repo_type:)
    end

    def job_step_logs_repo
      rom_key = strategy.call(job.name)
      repo_type = :job_step_logs
      repo_registry.resolve(rom_key:, repo_type:)
    end
  end
end
