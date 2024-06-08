# frozen_string_literal: true

require_relative '../../../test/helpers/test_helper'

class Garner::App::SettingsTest < Minitest::Test
  def setup
    @settings = Garnet.app['settings']
  end

  def test_settings_loaded_correctly
    refute_nil @settings.app_name, 'log_level should be present.'
    refute_nil @settings.log_level, 'app_name should be present.'
    refute_nil @settings.ingestion_job_enabled, 'simulation_job_enabled should be present.'
    refute_nil @settings.database_url, 'database_url should be present.'
    refute_nil @settings.elastic_apm_server_url, 'elastic_apm_server_url should be present.'
    refute_nil @settings.elastic_apm_enabled, 'elastic_apm_enabled should be present.'
  end
end
