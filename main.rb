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

  def boot_system # rubocop:disable Metrics/AbcSize
    Garnet.boot
    logger.debug("App name: #{Garnet.app.app_name}")
    logger.debug("App container: #{Garnet.app.keys}")
    logger.debug("App services: #{Garnet.services.keys.to_a}")
    logger.debug("Simulation container keys: #{Simulation::Service.keys}")
    logger.debug("Ingestion container keys: #{Ingestion::Service.keys}")
    logger.debug("Inventory container keys: #{Inventory::Service.keys}")
    logger.debug("Elastic container keys: #{Elastic::Service.keys}")
    logger.debug("Simulation Jobs: #{Simulation::Service['jobs']}")
    # logger.debug("Repository rom configurations: #{Garnet.app['persistence.config'].to_s}")
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
    @running = false
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
  sleep_interval = Garnet.app['settings'].sleep_interval
  while manager.running
    begin
      manager.run_all
      sleep sleep_interval
      break unless manager.running
    rescue Exception => e # rubocop:disable Lint/RescueException
      Garner::ExceptionManager.handle(e)
    ensure
      manager.shutdown
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  manager = ServiceManager.new
  manager.boot_system
  manager.add_service(:simulation, Simulation::Service['actors.simulator'])
  manager.add_service(:ingestion, Ingestion::Service['actors.collector'])
  main_event_loop(manager)
end
