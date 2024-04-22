# frozen_string_literal: true

require_relative '../../lib/app/persistence_strategies'

module Garner
  App.register :persistence_strategies, PersistenceStrategies.strategies
end
