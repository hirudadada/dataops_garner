# frozen_string_literal: true

module Garner
  App.class_eval do
    after(:settings) do
      database_configs = resolve(:settings).db_configs
      database_configs.each do |db_config|
        register_provider :persistence, source: :persistence, from: :garnet do
          config.name = db_config.db_name
          config.db_user = db_config.db_user
          config.db_password = db_config.db_password
          config.database_url = db_config.database_url
          config.enable_sql_log = db_config.enable_sql_log
        end
      end
    end
  end
end
#     # App.register_provider :persistence, source: :persistence, from: :my_framework do
#     #   config.db_user = target['settings'].db_user
#     #   config.db_password = target['settings'].db_password
#     #   config.database_url = target['settings'].database_url
#     #   config.enable_sql_log = target['settings'].enable_sql_log
#     #
#     #   # App.register_provider :archive_source, source: :persistence, from: :garnet do
#     #   #   config.name = 'source'
#     #   #   config.db_user = target['settings'].source_db_user
#     #   #   config.db_password = target['settings'].source_db_password
#     #   #   config.database_url = target['settings'].source_database_url
#     #   # end
#     #
#     #   # App.register_provider :archive_dest, source: :persistence, from: :garnet do
#     #   #   config.name = 'dest'
#     #   #   config.db_user = target['settings'].dest_db_user
#     #   #   config.db_password = target['settings'].dest_db_password
#     #   #   config.database_url = target['settings'].dest_database_url
#     #   # end
#   end
# end
