# frozen_string_literal: true

module Simulation
  module Actors
    class Simulator < Simulation::Actor
      include Deps['actions.run_next']
      include Deps['actions.start']
    end
  end
end
