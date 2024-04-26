# frozen_string_literal: true

require 'bundler/setup'
require 'garnet'
require 'async'
require 'logger'

require_relative 'app'

class ServiceManager
  attr_reader :logger, :running

  def initialize
    @services = {}
    @logger = Logger.new($stdout)
    @running = true
    setup_signal_traps
  end

  def boot_system
    Garnet.boot
    # logger.debug("App name: #{Garnet.app.app_name}")
    # logger.debug("App container: #{Garnet.app.keys}")
    # logger.debug("App services: #{Garnet.services.keys.to_a}")
    # logger.debug("Simulation container keys: #{Simulation::Service.keys}")
    # logger.debug("Ingestion container keys: #{Ingestion::Service.keys}")
    # logger.debug("Inventory container keys: #{Inventory::Service.keys}")
    # logger.debug("Elastic container keys: #{Elastic::Service.keys}")
    logger.info('App booted successfully.')
  end

  def add_service(key, service)
    @services[key] = service
  end

  def start_service(key)
    @services[key].request(:start)
  end

  def run_all
    @services.each_key { |service| start_service(service) }
  end

  def shutdown
    Garnet.shutdown
    logger.info('App shut down.')
  end

  protected

  def handle_error(error)
    logger.error("An error occurred: #{error.message}")
    Garner::ExceptionManager.handle(error)
  end

  def setup_signal_traps
    Signal.trap('INT') do
      p 'Received INT signal, preparing to shutdown.'
      @running = false
    end

    Signal.trap('TERM') do
      p 'Received TERM signal, preparing to shutdown.'
      @running = false
    end
  end
end

def main_event_loop(manager)
  while manager.running
    manager.run_all
    sleep 20
    break unless manager.running
  end
  manager.shutdown
end

if __FILE__ == $PROGRAM_NAME
  manager = ServiceManager.new
  manager.boot_system
  manager.add_service(:simulation, Simulation::Service['actors.simulator'])
  manager.add_service(:ingestion, Ingestion::Service['actors.collector'])
  main_event_loop(manager)
end
