# frozen_string_literal: true

require_relative '../lib/app/utils/persistence'

namespace :db do
  desc 'test connection and schema relations'
  task :check do
    Garner::Utils::Persistence.start_service
    Inventory::Service.finalize!

    Garner::Utils::Persistence.each_persistence do |key|
      provider = Garner::Utils::Persistence::Provider.new(key)

      source = provider.persistence.source

      puts 'Checking Db, ping...'
      puts " - Database url: #{source.config.database_url}"
      puts " - Db user: #{source.config.db_user}"
      puts " - Sql log enabled?: #{source.config.enable_sql_log}"

      valid, error_message = Garner::Utils::Persistence::Validator.new(provider.rom).call
      puts ' - Schema check:'
      if valid
        puts '   - Job log response is valid!'
      else
        puts "   - Error: #{error_message}"
      end
      puts 'Pong!'
    end
  rescue StandardError => e
    raise "Checking failed, #{e.message}"
  end
end
