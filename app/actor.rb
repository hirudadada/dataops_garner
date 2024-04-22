# frozen_string_literal: true

module Garner
  class Actor < Garnet::Actor::Base
    include Deps[:settings]
    include Deps[:logger]
    include Deps[:inflector]
  end
end
