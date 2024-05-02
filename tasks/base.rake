# frozen-string-literal: true

namespace :app do
  desc "Load environment settings"
  task :env do
    require "dotenv"
    Dotenv.load(*Dir["#{ENV['ENV_HOME']}/**/*.env"]) if Dir.exist?(ENV['ENV_HOME'])
    puts "Environment settings are loaded successfully"
  end

  desc "Show application version"
  task :version do
    if ENV['APP_VERSION'].nil?
      puts "App version: #{File.read('VERSION')}" if File.exist?('VERSION')
    else
      puts ENV['APP_VERSION']
    end
  end

  desc "Run the all services"
  task :ingest do
    require_relative '../main'

    manager = ServiceManager.new
    manager.boot_system
    manager.add_service(:simulation, Simulation::Service['actors.simulator'])
    manager.add_service(:ingestion, Ingestion::Service['actors.collector'])
    main_event_loop(manager)
  end

  desc "Run the ingestion service"
  task :ingest do
    require_relative '../main'

    manager = ServiceManager.new
    manager.boot_system
    manager.add_service(:simulation, Simulation::Service['actors.simulator'])
    manager.add_service(:ingestion, Ingestion::Service['actors.collector'])
    main_event_loop(manager)
  end

  desc "Run the simulation service"
  task :simulate do
    require_relative '../main'

    manager = ServiceManager.new
    manager.boot_system
    manager.add_service(:simulation, Simulation::Service['actors.simulator'])
    main_event_loop(manager)
  end
end

desc "Show version info"
task :version do
  Rake::Task['app:version'].invoke
end

desc "Perform configuration checks"
task :check do
  puts "Version check:"
  Rake::Task['version'].invoke
  puts
  puts "Elastic APM connection check"
  Rake::Task['elastic:check_connection'].invoke
  # puts "Database connection check:"
  # Rake::Task['db:test'].invoke
end
