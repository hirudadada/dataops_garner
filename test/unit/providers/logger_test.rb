# frozen_string_literal: true

require_relative '../../../garner'
require_relative '../../../test/helpers/test_helper'

class Garner::App::LoggerTest < Minitest::Test
  attr_reader :config, :settings

  def setup
    Garnet.prepare(:logger)
    @config = Garnet.app.providers[:logger].source.config
    @settings = Garnet.app['settings']
  end

  def test_allowed_level
    refute_nil config.name
    refute_nil config.log_formatter
    assert config.log_level == settings.log_level.to_sym
  end
end
