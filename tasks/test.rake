# frozen_string_literal: true

# Define a task to run all tests
Rake::TestTask.new(:test) do |t|
  t.libs << 'spec'
  t.pattern = 'spec/**/*_spec.rb'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Run a specific test file'
task :test_file, [:file] do |_t, args|
  if args[:file]
    Rake::TestTask.new(:run_specific_test) do |t|
      t.libs << 'spec'
      t.pattern = args[:file]
      t.verbose = true
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
      t.libs << 'spec'
      t.pattern = "#{args[:dir]}/**/*_spec.rb"
      t.verbose = true
      t.libs << 'test'
      t.pattern = "#{args[:dir]}/**/*_test.rb"
      t.verbose = true
    end
    Rake::Task[:run_specific_dir].invoke
  else
    puts 'Please provide a directory to run tests in. Example: rake test_dir[dir_name]'
  end
end
