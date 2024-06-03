# frozen_string_literal: true

module Garner
  class ServiceManager
    attr_reader :logger, :running

    def initialize
      @services = {}
      @enabled_services = {}
      @logger = Logger.new($stdout)
      @running = true
      setup_signal_traps
    end

    def boot_system # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
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
      check_environment_settings
    end

    def check_environment_settings
      disable_service(:simulation) unless Garnet.app['settings'].simulation_job_enabled
      disable_service(:ingestion) unless Garnet.app['settings'].ingestion_job_enabled
    end

    def add_service(key, service)
      @services[key] = service
      @enabled_services[key] = true
    end

    def enable_service(key)
      @enabled_services[key] = true
    end

    def disable_service(key)
      @enabled_services[key] = false
    end

    def start_service(key)
      return unless @enabled_services[key]

      @services[key].request(:start)
    end

    def run_all
      @services.each_key do |service|
        if @enabled_services[service]
          start_service(service)
        else
          logger.info("Service disabled: #{service}")
        end
      end
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
        logger.info('Received INT signal, preparing to shutdown.')
        @running = false
      end

      Signal.trap('TERM') do
        logger.info('Received TERM signal, preparing to shutdown.')
        @running = false
      end
    end
  end

  def main_event_loop(manager) # rubocop:disable Metrics/MethodLength
    sleep_interval = Garnet.app['settings'].sleep_interval
    while manager.running
      begin
        manager.run_all
        sleep sleep_interval
        break unless manager.running
      rescue Exception => e # rubocop:disable Lint/RescueException
        manager.handle_error(e)
      ensure
        manager.shutdown unless manager.running
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  manager = ServiceManager.new
  manager.boot_system
  manager.add_service(:simulation, Simulation::Service['actors.simulator'])
  manager.add_service(:ingestion, Ingestion::Service['actors.collector'])

  # manager.disable_service(:simulation)

  main_event_loop(manager)
end
