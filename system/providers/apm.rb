# frozen_string_literal: true

module Elastic
  Service.register_provider :apm do
    start { register(:apm, Garner::Elastic::Instrumentation.new) }
  end
end
