# frozen_string_literal: true

require_relative '../../../test/helpers/test_helper'

class Garner::App::ElasticApmAgentTest < Minitest::Test
  attr_reader :config, :default_options

  def setup
    Garnet.prepare(:elastic_apm_agent)
    @config = Garnet.app.providers[:elastic_apm_agent].source.config
    @default_options = Garnet.app['agent.default_options']
  end

  def test_ca_cert_file
    assert config.ca_cert_file.nil? || File.exist?(config.ca_cert_file), 'expect ca_cert_file to be valid or empty.'
  end

  def test_default_options
    refute_nil default_options[:verify_server_cert]
    refute_nil default_options[:log_level]
    refute_nil default_options[:logger]
    refute_nil default_options[:environment]
  end
end
