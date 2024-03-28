# frozen_string_literal: true

module Ingestion
  module Messages
    class CompleteJobLogsMessage < Garnet::Message
      include Inventory::Deps['actions.update_job_logs_as_collected.contract']

      from 'ingestion.actors.collector'
      to 'inventory.actors.controller'
      action :update_job_logs_as_collected
      callback :handle_updated_as_collected
    end
  end
end
