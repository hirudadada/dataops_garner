# frozen_string_literal: true

require_relative 'constants'
require_relative 'env_db_sources'
require_relative 'yaml_db_sources'

module Garner
  module Persistence
    class DbSourcesProvider
      extend Dry::Configurable

      setting :db_config, default: ENV.fetch('DB_CONFIG', 'config/database.yml'), reader: true

      def self.provide
        if File.exist?(config.db_config)
          YamlDbSources.new(config.db_config)
        else
          EnvDbSources.new
        end
      end
    end
  end
end
