# frozen_string_literal: true

require_relative '../../helpers/test_helper'
require_relative '../../helpers/spec_helper'
require_relative '../../../system/providers/ingestion'

describe 'Ingestion::Service' do # rubocop:disable Metrics/BlockLength
  let(:container) { Ingestion::Service }
  let(:job) { container[:job] }

  before do
    @original_env = ENV.to_h
    ENV.delete('INGESTION_JOB_NAME')
    ENV.delete('INGESTION_JOB_BATCH_SIZE')
    ENV.delete('INGESTION_JOB_SLICE_SIZE')
    ENV.delete('INGESTION_JOB_BATCH_WAIT')
    ENV.delete('INGESTION_JOB_MAX_BATCHES')
    ENV.delete('INGESTION_JOB_ENABLED')
  end

  after do
    ENV.replace(@original_env) # Reset ENV variables
  end

  describe 'with default settings' do
    before do
      default_config = load_fixture('default')
      Garnet.app['settings'].configure do |config|
        default_config.each do |key, value|
          config.public_send("#{key}=", value) if config.respond_to?("#{key}=")
        end
      end
      container.finalize!
    end

    it 'registers a job with default settings' do
      assert_equal 'default_job', job.name
      assert_equal 5, job.max_batches
    end
  end

  describe 'with field max batches null settings' do
    before do
      infinite_config = load_fixture('infinite_max_batches_null')
      Garnet.app['settings'].configure do |config|
        infinite_config.each do |key, value|
          config.public_send("#{key}=", value) if config.respond_to?("#{key}=")
        end
      end
      container.finalize!
    end

    it 'registers a job with infinite settings' do
      assert_equal 'infinite_max_batches_null', job.name
      assert_equal Float::INFINITY, job.max_batches
    end
  end

  describe 'with field max batches missed settings' do
    before do
      infinite_config = load_fixture('infinite_max_batches_missed')
      Garnet.app['settings'].configure do |config|
        infinite_config.each do |key, value|
          config.public_send("#{key}=", value) if config.respond_to?("#{key}=")
        end
      end
    end

    it 'registers a job with infinite settings' do
      assert_equal 'infinite_max_batches_missed', job.name
      assert_equal Float::INFINITY, job.max_batches
    end
  end

  describe 'with invalid environment vairables' do
    before do
      invalid_config = load_fixture('invalid')
      Garnet.app['settings'].configure do |config|
        invalid_config.each do |key, value|
          config.public_send("#{key}=", value) if config.respond_to?("#{key}=")
        end
      end
    end
  end

  it 'handles invalid variables gracefully' do
    assert_equal 'invalid_job', job.name
    assert_nil job.slice_size
    assert_equal Float::INFINITY, job.max_batches
  end
end
