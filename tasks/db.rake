# frozen_string_literal: true

require_relative '../lib/garner/utils/persistence'

namespace :db do
  desc 'test connection and schema relations'
  task :check do
    require Garnet.app.root.join('system/providers/persistence')
    Garner::Utils::Persistence.setup
    begin
      Garner::Utils::Persistence.each_provider(container: Garnet.app) do |provider|
        puts 'Checking Db, ping...'
        provider.check
        puts " - Database url: #{provider.persistence.source.config.database_url}"
        puts " - Db user: #{provider.persistence.source.config.db_user}"
        puts " - Sql log enabled?: #{provider.persistence.source.config.enable_sql_log}"
        puts 'Pong!'
      end
    rescue StandardError => e
      raise "Checking failed, #{e.message}"
    end
  end
end
