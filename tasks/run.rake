# frozen_string_literal: true

desc "Run the application"
task :run do
  require_relative '../main'

  manager = ServiceManager.new
  manager.boot_system
  manager.add_service(:simulation, Simulation::Service['actors.simulator'])
  manager.add_service(:ingestion, Ingestion::Service['actors.collector'])
  main_event_loop(manager)
end
