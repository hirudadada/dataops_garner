# frozen_string_literal: true

require_relative '../services/elastic/custom_error'

require_relative 'exception_manager'

module Garner
  class ProvisionExceptionManager
    include ExceptionManager

    error Garner::InvalidConfigurationError do |e|
      puts "Invalid configuration: #{e.message}"
      raise e
    end

    error Garner::InvalidProviderError do |e|
      puts "Invalid provider: #{e.message}"
      raise e
    end

    error Elastic::TransactionCreationError do |e|
      puts "Error creating transactions: #{e.message}"
      raise e
    end

    error Elastic::SpanCreationError do |e|
      puts "Error creating span: #{e.message}"
      raise e
    end
  end
end
