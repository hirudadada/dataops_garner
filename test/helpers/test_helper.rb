# frozen_string_literal: true

require_relative '../support/env'
require_relative '../support/settings'

require 'minitest/autorun'
require 'minitest/pride'

class Minitest::Test
  include Settings
end
