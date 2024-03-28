# frozen_string_literal: true

module Ingestion
  module Messages
    class SubmitToElasticMessage < Garnet::Message
      from 'ingestion.actors.collector'
      to 'elastic.actors.agent'
      action :intake_job_logs
      callback :handle_submitted
    end
  end
end
