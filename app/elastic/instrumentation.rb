# frozen_string_literal: true

module Garner
  module Elastic
    class Instrumentation
      include Deps['logger']

      def running? = ElasticAPM.running?

      def with_span(name, started, ended) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        span = ElasticAPM.start_span name
        span.start(ElasticAPM::Util.micros(started))
        span.instance_variable_set(:@timestamp, ElasticAPM::Util.micros(started))
        span.done clock_end: ElasticAPM::Util.micros(ended)
        yield span
      rescue StandardError => e
        logger.info "Unable to create span, #{e}"
        end_error_span(span, e)
        raise e
      ensure
        ElasticAPM.agent.instrumenter.current_spans.delete(span)
        ElasticAPM.agent.enqueue span
      end

      def with_transaction(name, started, ended) # rubocop:disable Metrics/MethodLength
        transaction = ElasticAPM.start_transaction name
        transaction.start(ElasticAPM::Util.micros(started))
        transaction.instance_variable_set(:@timestamp, ElasticAPM::Util.micros(started))
        yield transaction
      rescue StandardError => e
        logger.info "Unable to create transaction, #{e}"
        end_error_transaction(transaction, ended)
        raise e
      ensure
        ElasticAPM.agent.instrumenter.current_transaction = nil
        ElasticAPM.agent.enqueue transaction
      end

      def end_transaction(transaction, ended)
        transaction.done 'success', clock_end: ElasticAPM::Util.micros(ended)
        transaction.outcome = ElasticAPM::Transaction::Outcome::SUCCESS
      end

      def end_error_transaction(transaction, ended)
        transaction.done 'error', clock_end: ElasticAPM::Util.micros(ended)
        transaction.outcome = ElasticAPM::Transaction::Outcome::FAILURE
      end

      def end_span(span)
        span.outcome = ElasticAPM::Span::Outcome::SUCCESS
      end

      def end_error_span(span, error)
        if error.is_a?(String)
          ElasticAPM.report(StandardError.new(error))
        else
          ElasticAPM.report(error)
        end
        span.outcome = ElasticAPM::Span::Outcome::FAILURE
      end
    end
  end
end
