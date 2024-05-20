# frozen_string_literal: true

module Utils
  module Persistence
    def check_connection(rom)
      rom.relations[:job_logs]
         .limit(1)
         .combine(:job_step_logs)
         .to_a
    end

    def persistence_keys
      pattern = /^persistence([\..+]*)\.rom/
      Garnet.app.keys.grep pattern do |key|
        key.match(pattern).captures[0]
      end
    end
  end
end
