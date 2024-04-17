# frozen_string_literal: true

module Garner
  class ProvisionException < StandardError; end
  class InvalidConfigurationError < ProvisionException; end
  class InvalidServiceError < ProvisionException; end
  class InvalidProviderError < ProvisionException; end
  class InvalidJobError < ProvisionException; end
end
