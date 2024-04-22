# frozen_string_literal: true

require 'dry-configurable'
require 'dry-types'
require 'dry-struct'
require 'dry-validation'
require 'erb'
require 'yaml'

require_relative '../../lib/app/config_utils'

module Garner
  # TODO: will refactor if no further adaptation is needed.
  module Persistence
    module DbConfig
      @db_config = 'config/database.yml'
      @databases = {}

      class << self
        attr_accessor :db_config, :databases
        def database_config(db_identifier)
          databases[db_identifier.to_sym] ||= {}
        end

        def get_setting(setting_name)
          instance_variable_get("@#{setting_name}")
        end

        def set_setting(setting_name, value)
          instance_variable_set("@#{setting_name}", value)
        end
      end
      # extend Dry::Configurable
      #
      # setting :db_config, default: proc { 'config/database.yml' }
      # setting :databases, default: proc { {} }, reader: true
      #
      # def self.get_setting(setting_name)
      #   value = config.public_send(setting_name)
      #   value.is_a?(Proc) ? value.call : value
      # end
      #
      # def self.database_config(db_identifier)
      #   config.databases[db_identifier.to_sym] ||= {}
      # end
    end

    class DatabaseConfig < Dry::Struct
      attribute :db_user, Dry.Types::Strict::String
      attribute :db_password, Dry.Types::Strict::String
      attribute :database_url, Dry.Types::Strict::String
      attribute :enable_sql_log, Dry.Types::Strict::Bool.default(false)
      attribute :use_named_schema, Dry.Types::Strict::Bool.default(false)
      attribute :db_service, Dry.Types::Strict::String.optional
    end

    # DbConfigSchema = Dry::Schema.Params do
    #   required(:db_user).filled(:string)
    #   required(:db_password).filled(:string)
    #   required(:database_url).filled(:string)
    #   optional(:enable_sql_log).filled(:bool)
    #   optional(:use_named_schema).filled(:bool)
    #   optional(:db_service).filled(:string)
    # end

    DbConfigSchema = Dry::Validation.Contract do
      params do
        required(:db_user).filled(:string)
        required(:db_password).filled(:string)
        required(:database_url).filled(:string)
        optional(:enable_sql_log).filled(:bool)
        optional(:use_named_schema).filled(:bool)
        optional(:db_service).maybe(:string)
      end

      rule(:db_service) do
        key.failure("must be provided when use_named_schema is true") if values[:use_named_schema] && value.nil?
      end
    end

    class << self
      def convert_and_validate_config(settings)
        db_config = DatabaseConfig.new(**settings)
        result = DbConfigSchema.call(db_config.to_h)
        raise ArgumentError, result.errors.to_h unless result.success?
        db_config
      end

      def determine_rom_key(db_identifier, settings)
        raise ArgumentError, "settings must be a hash, got #{settings.class}" unless settings.is_a?(Hash)
        name = db_identifier
        if settings[:db_service]
          name = settings[:db_service].downcase.to_sym
        end
        ConfigUtils.format_for_path(name.to_s).to_sym
      end

      def load_from_yaml
        db_config_path = DbConfig.config.db_config
        raise ArgumentError, "YAML configuration file not found: #{db_config_path}" unless File.exist?(db_config_path)

        YAML.safe_load(ERB.new(File.read(db_config_path)).result, aliases: true).each do |key, settings|
          # determine_rom_key
          db_identifier = determine_rom_key(key.to_sym, settings)
          DbConfig.config.databases[db_identifier] = convert_and_validate_config(settings.symbolize_keys)
        end
      end

      def parse_env_value(key, value)
        case key
        when :enable_sql_log, :use_named_schema
          value == 'true'
        else
          value
        end
      end

      def load_from_env
        temp_databases = {}

        puts 'Loading from ENV'
        ENV.each do |key, value|
          # match = key.match(/^DB__([^\_]+)__(.+)$/)
          # next unless match

          next unless key.start_with?('DB__')

          parts = key.split('__')
          if parts.length == 3
            # DB__<IDENTIFIER>__<SETTING>
            db_identifier, setting_key = parts[1].downcase.to_sym, parts[2].downcase.to_sym
          elsif parts.length == 2
            # DB__<SETTING> for the default database
            db_identifier, setting_key = :default, parts[1].downcase.to_sym
          else
            next
          end

          # db_identifier, setting_key = match.captures.map(&:downcase).map(&:to_sym)

          setting_value = parse_env_value(setting_key, value)
          #     db_config = DbConfig.database_config(db_identifier)
          #     db_config[setting_key] = setting_value
          #   end
          #
          #   DbConfig.get_setting(:databases).transform_values! { |settings| convert_and_validate_config(settings) }
          # end

          temp_databases[db_identifier] ||= {}
          temp_databases[db_identifier][setting_key] = setting_value
        end

        # Consolidate configurations
        temp_databases.each do |db_identifier, settings|
          final_identifier = determine_rom_key(db_identifier, settings)
          if DbConfig.databases[final_identifier]
            DbConfig.databases[final_identifier].merge!(settings)
          else
            DbConfig.databases[final_identifier] = settings
          end
        end

        # Validate and convert all configurations
        DbConfig.databases.transform_values! { |settings| convert_and_validate_config(settings) }
      end

      def load_database_configurations
        load_from_yaml if File.exist?(DbConfig.get_setting(:db_config))
        load_from_env
      end

      def provider_name(rom_key) = "persistence.#{rom_key}".to_sym

      def register_providers
        DbConfig.get_setting(:databases).each do |rom_key, db_config|
          Garnet.app.register_provider(provider_name(rom_key), source: :persistence, from: :garnet) do
            config.name = rom_key.to_s
            config.db_user = db_config.db_user
            config.db_password = db_config.db_password
            config.database_url = db_config.database_url
            config.enable_sql_log = db_config.enable_sql_log
            config.use_named_schema = db_config.use_named_schema
          end
        end
      end

      def register_rom_keys
        # TODO: refactor as this
        # Garnet.app['persistence_keys'] = Garnet.app.resolve(:config).fetch(:persistence_keys)
        Garnet.app.register :persistence_keys, DbConfig.get_setting(:databases).keys
      end

      def load
        load_database_configurations
        register_providers
        register_rom_keys
      end
    end
  end

  Garner::Persistence.load
  # # For Debug
  # Persistence::DbConfig.get_setting(:databases).each do |rom_key, config_instance|
  #   puts "Configurations for #{rom_key}:"
  #   config_instance.instance_variables.each do |var|
  #     puts "  #{var.to_s.delete("@")}: #{config_instance.instance_variable_get(var)}"
  #   end
  # end
end
