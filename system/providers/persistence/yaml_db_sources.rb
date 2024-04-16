# frozen_string_literal: true

module Garner
  module Persistence
    # yaml sources that retrieve config/database.yml
    class YamlDbSources
      def fetch
        raise NotImplementedError 'Method #fetch must be implemented in subclass'
      end
    end
  end
end
