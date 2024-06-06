# frozen_string_literal: true

require_relative '../../../spec/helpers/test_helper'

class LoggerTest < Minitest::Test
  attr_reader :config, :settings

  def setup
    Garnet.prepare(:logger)
    @config = Garnet.app.providers[:logger].source.config
    @settings = Garnet.app['settings']
  end

  def test_allowed_level
    refute_nil config.app_name
    refute_nil config.formatter
    assert config.log_level == settings.log_level.to_sym
  end
end
