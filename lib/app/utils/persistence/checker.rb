# frozen_string_literal: true

require_relative '../../../../services/inventory'
require_relative '../../../../system/providers/inventory'

module Garner
  module Utils
    module Persistence
      class Checker
        include Inventory::Deps['operations.check_schema']

        def check
          check_schema.call
        end
      end
    end
  end
end
