# frozen_string_literal: true

require_relative '../lib/utils/persistence/check_connection'

namespace :db do
  desc 'test connection'
  task :check_connection do
    require_relative '../app/app'

    Garnet.boot

    rom_keys = Garnet.app.keys.select { |key| key.to_s.match(/persistence[\..+]*\.rom/) }

    rom_keys.each do |key|
      rom = Garnet.app.resolve(key)
      Utils::Persistence.check_connection(rom)
      puts 'Db connection successful.'
    rescue StandardError => e
      puts "Failed to connect db, #{e.message}"
    end
  end
end
