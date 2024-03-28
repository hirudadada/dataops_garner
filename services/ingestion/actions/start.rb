# frozen_string_literal: true

module Ingestion
  module Actions
    class Start < Ingestion::Action
      def handle(_params) = schedule_next_batch
    end
  end
end
