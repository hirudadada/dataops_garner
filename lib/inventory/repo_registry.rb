# frozen_string_literal: true

require 'dry-container'
require 'singleton'

require_relative 'repositories/job_logs_repo'
require_relative 'repositories/job_step_logs_repo'
require_relative '../../lib/app/persistence_strategies'

module Inventory
  class RepoRegistry
    include Singleton
    include Dry::Container::Mixin
    include Garner::PersistenceStrategies

    MAPPING = {
      job_logs: Repositories::JobLogsRepo,
      job_step_logs: Repositories::JobStepLogsRepo
    }

    use_strategy RemovePersistencePrefix

    def initialize
      super
      setup_repositories
    end

    def resolve(rom_key:, repo_type:)
      raise ArgumentError, 'Cannot resolve repository without rom_key or repo_type' if rom_key.nil? || repo_type.nil?

      super("repositories.#{rom_key}.#{repo_type}_repo")
    end

    def register_repository_factories(rom_key)
      raise ArgumentError, 'Cannot register repository factories without rom_key' if rom_key.nil?

      MAPPING.each do |repo_type, repo_class|
        register("repositories.#{rom_key}.#{repo_type}_repo") do
          repo_class.new(container: Garnet.app["persistence.#{rom_key}.rom"])
        end
      end
    end

    protected

    def setup_repositories
      each_database { |rom_key| register_repository_factories(rom_key) }
    end

    def each_database
      Garnet.app.resolve(:persistence_keys)&.each { |rom_key| yield strategy.nil? ? rom_key : strategy.call(rom_key) }
    end
  end
end
