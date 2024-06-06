# frozen_string_literal: true

module Garner
  App.register_provider :logger, from: :garnet do
    config.name = target['settings'].app_name
    config.log_formatter = target['settings'].log_formatter
    config.log_level = target['settings'].log_level
  end
end
