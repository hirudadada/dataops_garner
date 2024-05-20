# frozen_string_literal: true

module Elastic
  module Operations
    class SendApmLogs < Elastic::Operation
      include Deps['operations.context_manager']

      def call(job_logs)
        raise Elastic::AgentNotRunningError unless context_manager.apm_running?

        job_logs.each { |log| create_transaction(log) }
      end

      protected

      def create_transaction(log)
        error_occurred = :no_error
        context_manager.with_transaction(log[:name], log[:started_at], log[:ended_at]) do |transaction|
          error_occurred = create_spans(log[:job_step_logs])

          if error_occurred == :job_error
            context_manager.end_error_transaction(transaction, log[:ended_at])
          else
            context_manager.end_transaction(transaction, log[:ended_at])
          end
        end.tap { |x| logger.debug "calling from #{__method__} apm transaction: #{x}" }
      end

      def create_spans(steps)
        error_occurred = :no_error
        steps.each do |step|
          context_manager.with_span(step[:name], step[:started_at], step[:ended_at]) do |span|
            break context_manager.end_span(span) unless step[:error]

            error_occurred = :job_error
            context_manager.end_error_span(span, Elastic::CustomError.new(step[:error], at: step[:ended_at]))
          end
        end
        error_occurred
      end
    end
  end
end
