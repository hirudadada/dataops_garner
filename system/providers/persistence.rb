# frozen_string_literal: true

require_relative 'persistence/constants'
require_relative 'persistence/db_sources_provider'

module Garner
  # TODO: error handling
  db_sources = Persistence::DbSourcesProvider.provide.fetch
  App.register :persistence_ref, db_sources.map { |s| s[:name] }

  db_sources.each do |source|

    App.register_provider "persistence.#{source[:name]}".to_sym, source: :persistence, from: :garnet do
      config.name = source[:name]
      config.db_user = source[:db_user]
      config.db_password = source[:db_password]
      config.database_url = source[:database_url]
      config.enable_sql_log = source[:enable_sql_log]
      config.use_named_schema = source[:use_named_schema]
    end
  end
end
