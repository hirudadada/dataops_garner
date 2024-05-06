# frozen_string_literal: true

module Elastic
  class CustomError < StandardError
    attr_reader :filename, :lineno, :function

    def initialize(message, at:, filename: nil, lineno: nil, function: nil, backtrace: nil) # rubocop:disable Metrics/ParameterLists
      message = "At:#{at}-Message:#{message}"
      super(message)
      @filename = filename || default_filename
      @lineno = lineno || default_lineno
      @function = function || default_function
      set_backtrace(backtrace || default_backtrace)
    end

    private

    def default_filename
      'custom_file.rb'
    end

    def default_lineno
      123
    end

    def default_function
      'custom_method'
    end

    def default_backtrace
      [
        "custom_file.rb:123:in `custom_method'",
        "another_custom_file.rb:456:in `another_custom_method'"
      ]
    end
  end

  class TransactionCreationError < StandardError; end
  class SpanCreationError < StandardError; end
  class AgentNotRunningError < StandardError; end
end
