# frozen_string_literal: true

module Ingestion
  module Actions
    class Run < Ingestion::Actions::NextBatch
      include Deps['actions.run.contract']

      def handle(params)
        super(job: params[:job])
        schedule_next_batch
      end
    end
  end
end
