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

  def test_raw_config
    refute_nil config.verify_server_cert
    refute_nil config.log_level
    refute_nil config.logger
    refute_nil config.environment
  end
end
