# frozen_string_literal: true

module Garner
  ALL_LOGGER_LEVELS = %i[trace unknown error fatal warn info debug].freeze

  App.register_provider :logger, from: :garnet do
    # Adjust logger_level based on app_env
    app_env = target['settings'].app_env
    log_level = target['settings'].log_level.to_sym

    allowed_levels = case app_env
                     when :development
                       ALL_LOGGER_LEVELS
                     when :test, :production
                       ALL_LOGGER_LEVELS.reject { |level| level == :debug }
                     else
                       raise "Unsupported environment: #{app_env}"
                     end

    # Set the log level if valid, otherwise default to 'info'
    if allowed_levels.include?(log_level)
      config.log_level = log_level
    else
      puts "Invalid log level for #{app_env} environment: #{log_level}"
      config.log_level = :info
    end

    config.name = target['settings'].app_name
    config.log_formatter = target['settings'].log_formatter
  end
end
