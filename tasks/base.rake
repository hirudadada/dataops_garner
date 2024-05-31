# frozen_string_literal: true

namespace :app do
  desc 'Load environment settings'
  task :env do
    require 'dotenv'
    Dotenv.load(*Dir["#{ENV['ENV_HOME']}/**/*.env"]) if Dir.exist?(ENV['ENV_HOME'])
    puts 'Environment settings are loaded successfully'
  end

  desc 'Show application version'
  task :version do
    if ENV['APP_VERSION'].nil?
      puts "App version: #{File.read('VERSION')}" if File.exist?('VERSION')
    else
      puts ENV['APP_VERSION']
    end
  end
end

desc 'Show version info'
task :version do
  Rake::Task['app:version'].invoke
end

desc 'Perform configuration checks'
task :check do
  puts 'Version check:'
  Rake::Task['version'].invoke
  puts
  puts 'Elastic APM agent check:'
  Rake::Task['agent:check'].invoke
  puts
  puts 'Database check:'
  # TODO: do all testing
  Rake::Task['db:check'].invoke
end
