# frozen_string_literal: true

module Garner
  class Operation
    include Deps[:settings]
    include Deps[:logger]
    include Deps[:inflector]
    include Deps[:persistence_strategies]
  end
end
