# frozen_string_literal: true

require 'yaml'

module JobFixtures
  def load_fixture(name)
    fixtures_path = File.join(__dir__, '..', 'fixtures')
    file = File.join(fixtures_path, 'ingestion_job_configs.yaml')
    ::YAML.load_file(file)[name]
  end
end
