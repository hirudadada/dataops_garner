# frozen_string_literal: true

require_relative '../lib/app/utils/persistence'

namespace :db do
  desc 'test connection and schema relations'
  task :check do
    require Garnet.app.root.join('system/providers/persistence')
    Garnet.prepare(:persistence)
    Garnet.app.start(:persistence)
    Inventory::Service.finalize!
    begin
      Garner::Utils::Persistence.each_keys do |key|
        provider = Garner::Utils::Persistence::Provider.new(key)
        Garner::Utils::Persistence::Checker.new.check

        puts 'Checking Db, ping...'

        source = provider.persistence.source
        puts " - Database url: #{source.config.database_url}"
        puts " - Db user: #{source.config.db_user}"
        puts " - Sql log enabled?: #{source.config.enable_sql_log}"
        puts 'Pong!'
      end
    rescue StandardError => e
      raise "Checking failed, #{e.message}"
    end
  end
end
