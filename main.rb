# frozen_string_literal: true

require 'bundler/setup'
require 'garnet'
require 'async'

require_relative 'app'

begin
  Garnet.boot

  puts "App name: #{Garnet.app.app_name}"
  puts "App container: #{Garnet.app.keys}"
  puts "App services: #{Garnet.services.keys.to_a}"
  puts

  puts "Simulation container keys: #{Simulation::Service.keys}"
  puts "Ingestion container keys: #{Ingestion::Service.keys}"
  puts "Inventory container keys: #{Inventory::Service.keys}"
  puts "Elastic container keys: #{Elastic::Service.keys}"

  # p "Repository class methods: #{Garner::Repository.methods}"
  # p "Repository instance methods: #{Garner::Repository.instance_methods}"
  # p "Repository ancestors: #{Garner::Repository.ancestors}"
  # p "Repository included modules: #{Garner::Repository.included_modules}"
  # p "Repository instance variables: #{Garner::Repository.instance_variables}"
  # p "Repository constants: #{Garner::Repository.constants}"
  #
  # Garner::Repository.new.resolve('persistence.app_db1.rom')
  #
  # p "Action class methods: #{Inventory::Action.methods}"
  # p "Action instance methods: #{Inventory::Action.instance_methods}"
  # p "Action ancestors: #{Inventory::Action.ancestors}"
  # p "Action included modules: #{Inventory::Action.included_modules}"
  # p "Action instance variables: #{Inventory::Action.instance_variables}"
  # p "Action constants: #{Inventory::Action.constants}"
  #
  # p "Persistence class methods: #{Garner::Persistence.methods}"
  # p "Persistence instance methods: #{Garner::Persistence.instance_methods}"
  # p "Persistence ancestors: #{Garner::Persistence.ancestors}"
  # p "Persistence included modules: #{Garner::Persistence.included_modules}"
  # p "Persistence instance variables: #{Garner::Persistence.instance_variables}"
  # p "Persistence constants: #{Garner::Persistence.constants}"
  #
  # p "App class methods: #{Garner::App.methods}"
  # p "App instance methods: #{Garner::App.instance_methods}"
  # p "App ancestors: #{Garner::App.ancestors}"
  # p "App included modules: #{Garner::App.included_modules}"
  # p "App instance variables: #{Garner::App.instance_variables}"
  # p "App constants: #{Garner::App.constants}"
  #
  # p "App container: #{Garner::App.container}"
  # p "App services: #{Garner::App.services}"
  # p "App app_name: #{Garner::App.app_name}"
  # p "App keys: #{Garner::App.keys}"
  # p "App logger: #{Garner::App.logger}"
  # p "App config: #{Garner::App.config}"
  # p "App env: #{Garner::App.env}"
  # p "App root: #{Garner::App.root}"
  # p "App root_path: #{Garner::App.root_path}"
  # p "App root_pathname: #{Garner::App.root_pathname}"
  # p "App root_pathname: #{Garner::App.root_pathname}"
  # p "App root_pathname"
  Simulation::Service['actors.simulator'].request(:start)
  Ingestion::Service['actors.collector'].request(:start)
  # #
  # pp "Persistences: #{Garnet.app[:persistence_keys]}"
  sleep 20
  Garnet.shutdown
rescue Exception => e # rubocop:disable Lint/RescueException
  Garner::ExceptionManager.handle(e)
end
