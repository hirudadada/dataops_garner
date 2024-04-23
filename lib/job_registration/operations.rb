# frozen_string_literal: true

require_relative 'operations/create_config_from_settings'
require_relative 'operations/prepare_config'

module JobRegistration
  module Operations
    def self.extended(base)
      base.define_singleton_method(:create_config_from_settings) do |*args, **opts|
        CreateConfigFromSettings.new.call(*args, **opts)
      end

      base.define_singleton_method(:prepare_config) do |*args, **opts|
        PrepareConfig.new.call(*args, **opts)
      end
    end
  end
end
