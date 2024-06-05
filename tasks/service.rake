# frozen_string_literal: true

require_relative '../garner'

namespace :service do
  desc 'Run all services'
  task :all do
    manager = Garner::ServiceManager.new
    manager.boot_system
    manager.add_service(:simulation, Simulation::Service['actors.simulator'])
    manager.add_service(:ingestion, Ingestion::Service['actors.collector'])
    Garner::ServiceManager.main_event_loop(manager)
  end

  desc 'Run the ingestion service'
  task :ingest do
    manager = Garner::ServiceManager.new
    manager.boot_system
    manager.add_service(:ingestion, Ingestion::Service['actors.collector'])
    Garner::ServiceManager.main_event_loop(manager)
  end

  desc 'Run the simulation service'
  task :simulate do
    manager = Garner::ServiceManager.new
    manager.boot_system
    manager.add_service(:simulation, Simulation::Service['actors.simulator'])
    Garner::ServiceManager.main_event_loop(manager)
  end
end
