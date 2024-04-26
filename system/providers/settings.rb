# frozen_string_literal: true

require 'dry-types'

module Garner
  Dry::Types.load_extensions(:maybe)

  App.register_provider(:settings, from: :dry_system) do # rubocop:disable Metrics/BlockLength
    settings do # rubocop:disable Metrics/BlockLength
      setting :app_name, default: Garnet.app.app_name, constructor: Types::String.constrained(filled: true)
      setting :app_env, default: :production, constructor: Types::Symbol
        .constructor { |value| value.to_s.downcase.to_sym }
        .enum(:development, :test, :production)
      setting :service_name, constructor: Types::String.constrained(filled: true)

      setting :log_level, default: 'debug', constructor: Types::String.constrained(filled: true)
      setting :log_formatter, default: 'string', constructor: Types::String.constrained(filled: true)

      setting :db_name, constructor: Types::String.constrained(filled: true)
      setting :db_user, constructor: Types::String.constrained(filled: true)
      setting :db_password, constructor: Types::String.constrained(filled: true)
      setting :database_url, constructor: Types::String.constrained(filled: true)
      setting :enable_sql_log, default: false, constructor: Types::Params::Bool.constrained(filled: true)
      setting :use_named_schema, default: false, constructor: Types::Params::Bool.constrained(filled: true)

      setting :apm_server_url, constructor: Types::String.constrained(filled: true)
      setting :apm_secret_token, constructor: Types::String.constrained(filled: true)

      setting :simulation_job_name, default: 'simulation_job', constructor: Types::Optional::String
      setting :simulation_job_steps, default: 5, constructor: Types::Optional::Coercible::Integer.constrained(gteq: 1)
      setting :simulation_job_max_step_duration, default: 0.1, constructor: Types::Optional::Coercible::Float.constrained(gteq: 0.1)
      setting :simulation_job_error_rate, default: 0.01,
                                          constructor: Types::Optional::Coercible::Float.constrained(gteq: 0.0, lteq: 1.0)
      # Opt this env out if you want the job to run endlessly.
      setting :simulation_job_max_batches, default: Float::INFINITY,
                                           constructor: Types::Optional::Coercible::Float.constrained(gteq: 1)
      setting :simulation_job_batch_size, default: 10, constructor: Types::Optional::Coercible::Integer.constrained(gteq: 1)
      setting :simulation_job_batch_wait, default: 20, constructor: Types::Optional::Coercible::Float.constrained(gteq: 0.1)
      setting :simulation_job_iterations, default: 3, constructor: Types::Optional::Coercible::Integer.constrained(gteq: 1)

      setting :ingestion_job_name, default: 'ingestion_job', constructor: Types::Optional::String
      # Opt this env out if you want the job to run endlessly.
      setting :ingestion_job_max_batches, default: Float::INFINITY,
                                          constructor: Types::Optional::Coercible::Float.constrained(gteq: 1)
      setting :ingestion_job_batch_size, default: 20, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :ingestion_job_slice_size, default: 5, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :ingestion_job_batch_wait, default: 20, constructor: Types::Coercible::Float.constrained(gteq: 0.1)

      setting :simulator_pool_size, default: 3, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :collector_pool_size, default: 3, constructor: Types::Coercible::Integer.constrained(gteq: 1)

      setting :sleep_interval, default: 10, constructor: Types::Coercible::Integer.constrained(gteq: 1)
    end
  end
end
