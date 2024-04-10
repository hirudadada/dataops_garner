# frozen_string_literal: true

module Garner
  CASES = [
    {
      name: 'db1',
      db_user: 'user1',
      db_password: 'password1',
      database_url: 'postgres://user1:password1@db1-host:5432/dbname1',
      enable_sql_log: 'false'
    },
    {
      name: 'db2',
      db_user: 'user2',
      db_password: 'password2',
      database_url: 'postgres://user2:password2@db2-host:5432/dbname2',
      enable_sql_log: 'true'
    }
  ].freeze

  App.register_provider(:settings, from: :dry_system) do
    settings do
      setting :app_name, default: Garner.app.app_name, constructor: Types::String.constrained(filled: true)

      setting :log_level, default: 'info', constructor: Types::String.constrained(filled: true)
      setting :log_formatter, default: 'string', constructor: Types::String.constrained(filled: true)

      setting :fetch_size, default: 10, constructor: Types::Integer.constrained(filled: true)
      setting :db_name, constructor: Types::String.constrained(filled: true)
      setting :db_user, constructor: Types::String.constrained(filled: true)
      setting :db_password, constructor: Types::String.constrained(filled: true)
      setting :database_url, constructor: Types::String.constrained(filled: true)
      setting :enable_sql_log, default: false, constructor: Types::Params::Bool.optional

      setting :collector_pool_size, default: 2, constructor: Types::Integer.constrained(filled: true)
    end
  end

  DbConfig = Dry::Schema.Params do
    required(:db_user).filled(:string)
    required(:db_password).filled(:string)
    required(:database_url).filled(:string)
    required(:enable_sql_log).filled(:bool)

    optional(:db_name).filled(:string)

    optional(:log_level).filled(:string, default: 'info')
    optional(:log_formatter).filled(:string, default: 'string')
    optional(:fetch_size).filled(:bool, default: 10)
    optional(:collector_pool_size).filled(:bool, default: 2)
    optional(:simulator_pool_size).filled(:bool, default: 2)
  end


  App.register_provider(:settings, from: :dry_system) do
    settings do
      setting :app_name, default: MyFramework.app.app_name, constructor: Types::String.constrained(filled: true)

      setting :log_level, default: 'info', constructor: Types::String.constrained(filled: true)
      setting :log_formatter, default: 'string', constructor: Types::String.constrained(filled: true)

      setting :db_configs, constructor: Types::Array.of(DbConfig).constrained(filled: true)
    end
  end
end
