# frozen_string_literal: true

module Simulation
  module Messages
    class RunNextMessage < Garnet::Message
      include Deps['actions.run.contract']

      from 'simulation.actors.simulator'
      to 'simulation.actors.simulator'
      action 'run'
    end
  end
end
