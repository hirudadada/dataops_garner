# frozen_string_literal: true

require_relative '../../../test/helpers/test_helper'

class StringOrNilConfig
  attr_reader :constructor

  def initialize(constructor: nil)
    env_value = ENV.fetch('STRING_OR_NIL_ENV', nil)
    @constructor = Garner::Types::Coercible::StringOrNil[env_value || constructor]
  end
end

class StringOrNilConfigTest < Minitest::Test
  def setup
    ENV.delete('STRING_OR_NIL_ENV')
  end

  def test_defaults_to_nil
    config = StringOrNilConfig.new
    assert_nil config.constructor
  end

  def test_defaults_to_empty_string_equals_to_nil
    config = StringOrNilConfig.new(constructor: '')
    assert_nil config.constructor
  end

  def test_uses_env_variable_value
    str = 'i_have_some_config_for_testing'
    ENV['STRING_OR_NIL_ENV'] = str
    config = StringOrNilConfig.new
    assert_equal str, config.constructor
  end
end
