# frozen_string_literal: true

module Garner
  # IOC of Actions
  class Action < Garnet::Action
    include Deps[:settings]
    include Deps[:logger]
    include Deps[:inflector]
  end
end
