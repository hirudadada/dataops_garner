# frozen_string_literal: true

module Garner
  module ExceptionManager
    @handled_exceptions = {}

    class << self
      attr_reader :handled_exceptions

      def register(exception_class, handler)
        @handled_exceptions[exception_class] = handler
      end

      # alias []= register
      def [](exception_class)
        Module.new do
          define_singletone_method :included do |base|
            base.extend ClassMethods
            ProvisionExceptionManager.register(exception_class, base.method(:handle_exception))
          end
        end
      end

      def handle(exception)
        handler = @handled_exceptions[exception.class]
        if handler
          handler.call(exception)
        else
          puts "No handler found for #{exception.class}"
          raise exception
        end
      end

      alias call handle

      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods
      def handle_exception(exception)
        # Default exception handler, should be overridden by including class
        puts "No handler found for #{exception.class}"
        # puts "Handling #{exception.class}: #{exception.message}"
      end

      def error(exception_class, handler: nil, &block)
        ExceptionManager.register(exception_class, handler || block)
      end
    end
  end
end
