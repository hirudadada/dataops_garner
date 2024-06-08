# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'pry'

require_relative '../../garner'
require_relative '../support/settings'

require 'minitest/autorun'
require 'minitest/pride'

class Minitest::Test
  include Settings
end
