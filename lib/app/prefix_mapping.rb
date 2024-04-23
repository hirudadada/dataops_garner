# frozen_string_literal: true

module Garner
  module PrefixMapping
    def self.included(base)
      base.extend ClassMethods
      mappings.each do |name, proc|
        base.const_set(name, proc)
      end
    end

    def self.mappings
      {
        RemovePersistencePrefix: lambda { |rom_key|
          rom_key.to_s.downcase.sub(/.*?persistence\./, '').split('.').first
        },
        ConvertToSymbol: lambda { |rom_key|
          rom_key.to_s.downcase.to_sym
        }
      }
    end

    module ClassMethods
      def use_strategy(strategy_proc)
        define_method(:strategy) do
          strategy_proc
        end
      end
    end
  end
end
