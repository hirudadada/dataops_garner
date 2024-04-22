# frozen_string_literal: true

module Garner
  App.register_provider(:settings, from: :dry_system) do
    settings do
      setting :app_name, default: Garnet.app.app_name, constructor: Types::String.constrained(filled: true)
      setting :app_env, default: :production, constructor: Types::Symbol
        .constructor { |value| value.to_s.downcase.to_sym }
        .enum(:development, :test, :production)

      setting :log_level, default: 'info', constructor: Types::String.constrained(filled: true)
      setting :log_formatter, default: 'string', constructor: Types::String.constrained(filled: true)

      setting :simulator_pool_size, default: 2, constructor: Types::Coercible::Integer.constrained(gteq: 1)

      setting :simulation_job_name, default: 'simulation_job', constructor: Types::String.constrained(filled: true)
      setting :simulation_job_steps, default: 2, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :simulation_job_max_step_duration, default: 0.1, constructor: Types::Coercible::Float.constrained(gteq: 0.1)
      setting :simulation_job_error_rate, default: 0.01, constructor: Types::Coercible::Float.constrained(gteq: 0.0, lteq: 1.0)
      setting :simulation_job_max_batches, default: 5, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :simulation_job_batch_size, default: 10, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :simulation_job_batch_wait, default: 0.5, constructor: Types::Coercible::Float.constrained(gteq: 0.1)

      setting :ingestion_job_name, default: 'ingestion_job', constructor: Types::String.constrained(filled: true)
      setting :ingestion_job_max_batches, default: 5, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :ingestion_job_batch_size, default: 20, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :ingestion_job_slice_size, default: 5, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :ingestion_job_batch_wait, default: 1, constructor: Types::Coercible::Integer.constrained(gteq: 1)

      setting :collector_pool_size, default: 2, constructor: Types::Coercible::Integer.constrained(gteq: 1)
    end
  end
end
