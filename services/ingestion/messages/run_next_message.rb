# frozen_string_literal: true

module Ingestion
  module Messages
    class RunNextMessage < Garnet::Message
      include Deps['actions.run.contract']

      from 'ingestion.actors.collector'
      to 'ingestion.actors.collector'
      action 'run'
    end
  end
end
