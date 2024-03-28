# frozen_string_literal: true

module Simulation
  module Actors
    class Simulator < Simulation::Actor
      include Deps['actions.start']
      include Deps['actions.run']
    end
  end
end
