# frozen_string_literal: true

module Garner
  module PersistenceStrategies
    def self.included(base)
      base.extend ClassMethods
      strategies.each do |name, proc|
        base.const_set(name, proc)
      end
    end

    def self.strategies
      {
        RemovePersistencePrefix: ->(rom_key) {
          rom_key.to_s.downcase.sub(/.*?persistence\./, '').split('.').first
        },
        ConvertToSymbol: ->(rom_key) {
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
