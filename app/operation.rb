# frozen_string_literal: true

module Garner
  # IOC of Operations
  class Operation
    include Deps[:settings]
    include Deps[:logger]
    include Deps[:inflector]
  end
end
