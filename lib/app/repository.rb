# frozen_string_literal: true

require 'rom-repository'

module Garner
  class Repository < ROM::Repository::Root
    attr_accessor :container

    def initialize(container: nil)
      container ||= Deps['persistence.rom']
      super(container)
    end
  end
end
