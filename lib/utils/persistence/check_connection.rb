# frozen_string_literal: true

module Utils
  module Persistence
    def self.check_connection(rom)
      rom.relations[:job_logs]
        .limit(1)
        .combine(:job_step_logs)
        .to_a
    end
  end
end
