# frozen_string_literal: true

require 'bundler/setup'
require 'garnet'
require 'async'
require 'logger'

require_relative 'app'

logger = Logger.new($stdout)

def main_loop
  logger = Logger.new($stdout)
  running = true

  Signal.trap("INT") do
    logger.info("Received INT signal, preparing to shutdown.")
    running = false
  end

  Signal.trap("TERM") do
    logger.info("Received TERM signal, preparing to shutdown.")
    running = false
  end

  begin
    Garnet.boot
    logger.info("App booted successfully.")
    #   puts "App name: #{Garnet.app.app_name}"
    #   puts "App container: #{Garnet.app.keys}"
    #   puts "App services: #{Garnet.services.keys.to_a}"
    #   puts
    #
    #   puts "Simulation container keys: #{Simulation::Service.keys}"
    #   puts "Ingestion container keys: #{Ingestion::Service.keys}"
    #   puts "Inventory container keys: #{Inventory::Service.keys}"
    #   puts "Elastic container keys: #{Elastic::Service.keys}"

    logger.info("Services started.")

    while running
      Simulation::Service['actors.simulator'].request(:start)
      Ingestion::Service['actors.collector'].request(:start)

      break if running == false
    end
  rescue StandardError => e
    logger.error("An error occurred: #{e.message}")
    Garner::ExceptionManager.handle(e)
  ensure
    Garnet.shutdown
    logger.info("App shut down.")
  end
end

if __FILE__ == $0
  main_loop
end
