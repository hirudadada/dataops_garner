# frozen_string_literal: true

module Garner
  class ProvisionException < StandardError; end
  class InvalidConfigurationError < ProvisionException; end
  class InvalidProviderError < ProvisionException; end
end
