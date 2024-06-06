# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require_relative '../support/job_fixtures'

class Minitest::Spec
  include JobFixtures
end
