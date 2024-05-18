# frozen_string_literal: true

require_relative '../lib/utils/persistence/check_connection'

namespace :db do
  desc 'test connection'
  task :check_connection do
    require Garnet.app.root.join('system/providers/persistence')
    include Utils::Persistence

    Garnet.prepare(:persistence)
    Garnet.app.start(:persistence)

    begin
      persistence_keys.each do |key|
        named = !key.empty?
        provider_key = named ? :"persistence#{key}" : :persistence
        rom_key = :"#{provider_key}.rom"
        provider = Garnet.app.providers[provider_key]

        puts 'Checking Db...'
        check_connection(Garnet.app[rom_key])
        puts '-- Connection --'
        puts "db_user: #{provider.source.config.db_user}"
        puts "database_url: #{provider.source.config.database_url}"
        puts "enable_sql_log: #{provider.source.config.enable_sql_log}"
      end
      puts 'Database is connected.'
    rescue StandardError => e
      raise "Database connection failed, #{e.message}"
    end
  end
end
