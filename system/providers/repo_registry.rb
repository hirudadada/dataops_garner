# frozen_string_literal: true

require_relative '../../lib/inventory/repo_registry'

module Inventory
  Service.register_provider :repo_registry do
    start do
      # register(:repo_registry, RepoRegistry.instance(Garnet.app.resolve(:persistence_keys)))
      register(:repo_registry, RepoRegistry.instance)
    end
  end
end
