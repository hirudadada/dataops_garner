# frozen_string_literal: true

require 'bundler/setup'
require 'garnet'
require 'async'
require 'logger'

require_relative 'app'
require_relative 'lib/service_manager'

if __FILE__ == $PROGRAM_NAME
  manager = ServiceManager.new
  manager.boot_system
  # manager.add_service(:simulation, Simulation::Service['actors.simulator'])
  manager.add_service(:ingestion, Ingestion::Service['actors.collector'])

  # manager.disable_service(:simulation)

  main_event_loop(manager)
end
