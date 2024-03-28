# frozen_string_literal: true

module Simulation
  module Actors
    # Simulation Actor calls for job_logs simulation
    class Simulator < Garner::ActorPool
      # The worker class
      class Worker < Simulation::Actor
        include Deps['actions.run']
        include Deps['actions.start']
      end

      actor_class Worker
      size { settings.simulator_pool_size }
    end

    # class Simulator < Simulation::Actor
    #   include Deps['actions.run']
    #   include Deps['actions.start']
    # end
  end
end
