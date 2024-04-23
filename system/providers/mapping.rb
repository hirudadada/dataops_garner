# frozen_string_literal: true

require_relative '../../lib/app/prefix_mapping'

module Garner
  App.register :mapping, PrefixMapping.mappings
end
