# frozen_string_literal: true

require_relative '../lib/utils/persistence'

namespace :db do
  desc 'test connection and schema relations'
  task :check do
    require Garnet.app.root.join('system/providers/persistence')

    Garnet.prepare(:persistence)
    Garnet.app.start(:persistence)

    begin
      Utils::Persistence.each_keys(container: Garnet.app) do |key|
        puts 'Checking Db, ping...'
        connection_helper = Utils::Persistence::Connection.new(key)
        connection_helper.check
        puts " - Database url: #{connection_helper.provider.source.config.database_url}"
        puts " - Db user: #{connection_helper.provider.source.config.db_user}"
        puts " - Sql log enabled?: #{connection_helper.provider.source.config.enable_sql_log}"
        puts 'Pong!'
      end
    rescue StandardError => e
      raise "Checking failed, #{e.message}"
    end
  end
end
