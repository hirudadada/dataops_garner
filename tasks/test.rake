# frozen_string_literal: true

# Define a task to run all tests
namespace :test do # rubocop:disable Metrics/BlockLength
  Rake::TestTask.new(:unit) do |t|
    t.libs << 'test'
    t.pattern = 'test/unit/**/*_test.rb'
    t.verbose = true
  end

  Rake::TestTask.new(:integration) do |t|
    t.libs << 'test'
    t.pattern = 'test/integration/**/*_test.rb'
    t.verbose = true
  end

  desc 'Run a specific test file'
  task :test_file, [:file] do |_t, args|
    if args[:file]
      Rake::TestTask.new(:run_specific_test) do |t|
        t.libs << 'test'
        t.pattern = args[:file]
        t.verbose = true
      end
      Rake::Task[:run_specific_test].invoke
    else
      puts 'Please provide a test file to run. Example: rake test_file[file_name]'
    end
  end

  # Define a task to run tests in a specific directory
  desc 'Run tests in a specific directory'
  task :test_dir, [:dir] do |_t, args|
    if args[:dir]
      Rake::TestTask.new(:run_specific_dir) do |t|
        t.libs << 'test'
        t.pattern = "#{args[:dir]}/**/*_test.rb"
        t.verbose = true
      end
      Rake::Task[:run_specific_dir].invoke
    else
      puts 'Please provide a directory to run tests in. Example: rake test_dir[dir_name]'
    end
  end

  task all: %i[unit integration]
end

task default: 'test:all'
