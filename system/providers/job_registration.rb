# frozen_string_literal: true

require_relative '../../lib/job_registration/ingestion_job'
require_relative '../../lib/job_registration/simulation_job'

module Ingestion
  Service.register_provider :ingestion_jobs do
    start do
      JobRegistration::IngestionJob.register_ingestion_jobs(Service)
    end
  end
end

module Simulation
  Service.register_provider :simulation_jobs do
    start do
      JobRegistration::SimulationJob.register_simulation_jobs(Service)
    end
  end
end
