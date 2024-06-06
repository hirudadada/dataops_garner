# frozen_string_literal: true

module Garner
  class Env
    include Deps[:settings]

    def staging? = Constants::StagingLevels::LEVELS.include?(settings.app_env)
  end
end
