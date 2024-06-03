# frozen_string_literal: true

require_relative '../../test_helper'

class ElasticApmAgentTest < Minitest::Test
  attr_reader :config
  def setup
    Garnet.prepare(:elastic_apm_agent)
    @config = Garnet.app.providers[:elastic_apm_agent].source.config
  end

  def test_ca_cert_file
    assert config.ca_cert_file.nil? || File.exist?(config.ca_cert_file), 'expect ca_cert_file to be valid or empty.'
  end

  def test_config_loaded
    refute_nil config.enabled, 'enabled should be present.'
    refute_nil config.service_name, 'service_name should be present.'
    refute_nil config.url, 'server_url should be present.'
    refute_nil config.pool_size, 'pool_size should be present.'
  end
end

