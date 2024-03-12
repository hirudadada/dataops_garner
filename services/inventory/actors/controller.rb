# frozen_string_literal: true

module Inventory
  module Actors
    class Controller < Inventory::Actor
      include Deps['actions.create_job_logs']
    end
  end
end
