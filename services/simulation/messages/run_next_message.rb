# frozen_string_literal: true

module Simulation
  module Messages
    # signifys next run
    class RunNext < Garnet::Message
      from 'simulation.actors.simulator'
      to 'simulation.actors.simulator'
      action :run_next
    end
  end
end
