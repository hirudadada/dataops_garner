# frozen_string_literal: true

module Elastic
  module Operations
    class SendApmLogs < Elastic::Operation
      include Deps['apm']

      def call(job_logs)
        return nil unless apm.running?

        job_logs.each { |log| create_transaction(log) }
      end

      protected

      def create_transaction(log)
        error_occurred = :no_error
        apm.with_transaction(log[:name], log[:started_at], log[:ended_at]) do |transaction|
          error_occurred = create_spans(log[:job_step_logs])

          if error_occurred == :job_error
            apm.end_error_transaction(transaction, log[:ended_at])
          else
            apm.end_transaction(transaction, log[:ended_at])
          end
        end
      end

      def create_spans(steps)
        error_occurred = :no_error
        steps.each do |step|
          apm.with_span(step[:name], step[:started_at], step[:ended_at]) do |span|
            break apm.end_span(span) unless step[:error]

            error_occurred = :job_error
            apm.end_error_span(span, Elastic::CustomError.new(step[:error], at: step[:ended_at]))
          end
        end
        error_occurred
      end
    end
  end
end
