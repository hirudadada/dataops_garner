# frozen_string_literal: true

require_relative '../../helpers/test_helper'
require 'dry-types'

module Types
  include Dry.Types()
end

class CoercionTest < Minitest::Test
  def test_invalid_integer_coercion
    error = assert_raises(Dry::Types::CoercionError) do
      Types::Coercible::Integer['invalid_size']
    end
    assert_equal 'invalid value for Integer(): "invalid_size"', error.message
  end
end
