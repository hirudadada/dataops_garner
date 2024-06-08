# frozen_string_literal: true

module Garner
  module Utils
    module Persistence
      def self.start_service
        require Garnet.app.root.join 'system/providers/persistence'
        require Garnet.app.root.join 'system/providers/mappings'

        Garnet.prepare(:persistence)
        Garnet.app.start(:persistence)
        Inventory::Service.finalize!
      end
    end
  end
end
