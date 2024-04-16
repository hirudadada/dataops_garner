# frozen_string_literal: true

require_relative 'persistence/db_sources_provider'

module Garner
  db_sources = Persistence::DbSourcesProvider.provide.fetch
  db_sources.each do |source|
    App.register_provider source[:name], source: :persistence, from: :garnet do
      config.name = source[:name]
      config.db_user = source[:db_user]
      config.db_password = source[:db_password]
      config.database_url = source[:database_url]
      config.enable_sql_log = source[:enable_sql_log]
    end
  end
end
