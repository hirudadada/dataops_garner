# frozen_string_literal: true

require_relative '../../test_helper'

class LoggerTest < Minitest::Test
  attr_reader :config, :settings

  def setup
    Garnet.prepare(:logger)
    @config = Garnet.app.providers[:logger].source.config
    @settings = Garnet.app['settings']
  end

  def test_allowed_level
    assert config.log_level == settings.log_level.to_sym
  end
end
