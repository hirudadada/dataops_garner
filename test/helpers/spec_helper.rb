# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'

require_relative '../support/settings'

class Minitest::Spec
  include Settings
end
