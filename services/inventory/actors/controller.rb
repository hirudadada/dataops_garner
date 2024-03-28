# frozen_string_literal: true

module Inventory
  module Actors
    class Controller < Inventory::Actor
      include Deps['actions.create_job_logs']
      include Deps['actions.find_job_logs']
      include Deps['actions.update_job_logs_as_collected']
    end
  end
end
