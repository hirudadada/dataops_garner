# frozen_string_literal: true

require_relative '../../../spec/helpers/test_helper'

class IngestionJobsTest < Minitest::Test
  attr_reader :config

  def setup
    Garnet.prepare(:ingestion_jobs)
  end
end
