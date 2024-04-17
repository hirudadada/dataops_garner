# frozen_string_literal: true

require_relative 'exception_manager'

module Garner
  class ProvisionExceptionManager
    include ExceptionManager

    error ArgumentError do |e|
      puts "Invalid argument: #{e.message}"
      raise e
    end

    error Dry::Types::ConstraintError do |e|
      puts "Invalid type: #{e.message}"
      raise e
    end

    error Garner::InvalidConfigurationError do |e|
      puts "Invalid configuration: #{e.message}"
      raise e
    end

    error Garner::InvalidServiceError do |e|
      puts "Invalid service: #{e.message}"
      raise e
    end

    error Garner::InvalidProviderError do |e|
      puts "Invalid provider: #{e.message}"
      raise e
    end

    error Garner::InvalidJobError do |e|
      puts "Invalid job: #{e.message}"
      raise e
    end
  end
end
