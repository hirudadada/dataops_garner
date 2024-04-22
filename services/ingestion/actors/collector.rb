# frozen_string_literal: true

module Ingestion
  module Actors
    class Collector < Garner::ActorPool
      class Worker < Ingestion::Actor
        include Deps['actions.run']
        include Deps['actions.start']
        include Deps['actions.handle_fetched_job_logs']
        include Deps['actions.handle_submitted']
        include Deps['actions.handle_updated_as_collected']
      end

      actor_class Worker
      size { settings.collector_pool_size }
    end
  end
end

# module Ingestion
#   module Actors
#     class Collector < Ingestion::Actor
#       include Deps['actions.start']
#       include Deps['actions.handle_fetched_job_logs']
#       include Deps['actions.handle_submitted']
#       include Deps['actions.handle_updated_as_collected']
#     end
#   end
# end
