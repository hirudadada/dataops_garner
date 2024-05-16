# frozen_string_literal: true

require 'dry/types'

module Garner
  module Types
    include Dry::Types()

    Coercible::StringOrNil = Dry::Types['optional.string'].constructor do |str|
      str = str.to_s.strip
      str.empty? ? nil : str
    end
  end
end
