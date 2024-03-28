# frozen_string_literal: true

module Garner
  # IOC of ActorPools
  class ActorPool < Garnet::Actor::Pool
    include Deps[:settings]
    include Deps[:logger]
    include Deps[:inflector]
  end
end
