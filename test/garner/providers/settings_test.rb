# frozen_string_literal: true

require_relative '../../test_helper'

class SettingsTest < Minitest::Test
  def setup
    @settings = Garnet.app['settings']
  end

  def test_settings_loaded_correctly
    refute_nil @settings.log_level, 'log_level should be present.'
    refute_nil @settings.ingestion_job_enabled, 'simulation_job_enabled should be present.'
    refute_nil @settings.ingestion_job_max_batches, 'ingestion_job_max_batches should be present.'
    refute_nil @settings.database_url, 'database_url should be present.'
    refute_nil @settings.elastic_apm_server_url, 'elastic_apm_server_url should be present.'
    refute_nil @settings.elastic_apm_enabled, 'elastic_apm_enabled should be present.'
  end
end
