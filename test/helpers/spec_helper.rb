# frozen_string_literal: true

require_relative '../support/env'
require_relative '../support/settings'

require 'minitest/autorun'
require 'minitest/spec'

class Minitest::Spec
  include Settings
end
