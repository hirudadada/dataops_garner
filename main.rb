# frozen_string_literal: true

require 'bundler/setup'
require 'garnet'

require 'async'

require_relative 'app'

Garnet.boot

puts "App name: #{Garnet.app.app_name}"
puts "App container: #{Garnet.app.keys}"
puts "App services: #{Garnet.services.keys.to_a}"
puts

puts "Simulation container keys: #{Simulation::Service.keys}"
puts "Ingestion container keys: #{Ingestion::Service.keys}"
puts "Inventory container keys: #{Inventory::Service.keys}"
puts "Elastic container keys: #{Elastic::Service.keys}"

Simulation::Service['actors.simulator'].request(:start)
Ingestion::Service['actors.collector'].request(:start)

sleep 20
Garnet.shutdown
