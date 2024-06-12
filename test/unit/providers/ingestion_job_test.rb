# frozen_string_literal: true

require 'yaml'
require_relative '../../../garner'
require_relative '../../helpers/test_helper'

class Ingestion::Service::IngestionJobTest < Minitest::Test
  PREFIX = 'INGESTION_'
  SETTINGS = %w[ingestion_job_name ingestion_job_batch_size ingestion_job_slice_size ingestion_job_batch_wait
                ingestion_job_max_batches].freeze

  attr_reader :original_env

  def setup
    require Garnet.app.root.join 'system/providers/ingestion/job'
    @original_env = ENV.to_h
    ENV.keys.grep(/^#{PREFIX}/).each { |key| ENV.delete(key) }
  end

  def teardown
    ENV.replace(original_env)
  end

  def test_ingestion_settings
    SETTINGS.each do |option|
      assert Garnet.app[:settings].respond_to?(option.to_sym)
    end
  end

  def test_with_default_settings
    config = configure_from_fixture(name: 'default')
    assert_equal config['ingestion_job_name'], job.name
    assert_equal config['ingestion_job_max_batches'], job.max_batches
  end

  def test_with_field_max_batches_null_settings
    config = configure_from_fixture(name: 'infinite_max_batches_null')
    assert_equal config['ingestion_job_name'], job.name
    assert_equal Float::INFINITY, job.max_batches
  end

  def test_with_field_max_batches_missed
    config = configure_from_fixture(name: 'infinite_max_batches_missed')
    assert_equal config['ingestion_job_name'], job.name
    assert_equal Float::INFINITY, job.max_batches
  end

  protected

  def container = Ingestion::Service

  def job = container[:job]

  def options
    SETTINGS.each_with_object({}) { |key, result| result[key] = nil }
  end

  def configure_from_fixture(name:)
    load_fixture(name:).tap do |config|
      configure_settings(Garnet.app, options.merge(config))
      container.finalize!
    end
  end

  def load_fixture(name:)
    fixtures_path = File.join(__dir__, '../../', 'fixtures')
    file = File.join(fixtures_path, 'ingestion_job_configs.yaml')
    ::YAML.load_file(file)[name]
  end
end
