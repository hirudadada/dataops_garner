# frozen_string_literal: true

require 'dry-types'

module Garner
  App.register_provider(:settings, from: :dry_system) do # rubocop:disable Metrics/BlockLength
    settings do # rubocop:disable Metrics/BlockLength
      # General Settings
      setting :app_name, default: Garnet.app.app_name, constructor: Types::String.constrained(filled: true)
      setting :app_env, default: :production, constructor: Types::Symbol
        .constructor { |value| value.to_s.downcase.to_sym }
        .enum(:development, :test, :production)
      setting :log_level, default: 'debug', constructor: Types::String.constrained(filled: true)
      setting :log_formatter, default: 'string', constructor: Types::String.constrained(filled: true)

      # DB
      setting :db_host, constructor: Types::String.constrained(filled: true)
      setting :db_name, constructor: Types::String.constrained(filled: true)
      setting :db_user, constructor: Types::String.constrained(filled: true)
      setting :db_password, constructor: Types::Optional::String
      setting :db_password_encrypted, constructor: Types::Optional::String
      setting :database_url, constructor: Types::String.constrained(filled: true)
      setting :enable_sql_log, default: false, constructor: Types::Params::Bool.constrained(filled: true)
      setting :use_named_schema, default: false, constructor: Types::Params::Bool.constrained(filled: true)

      # Apm
      setting :apm_server_url, constructor: Types::String.constrained(filled: true)
      setting :apm_secret_token, constructor: Types::Optional::String
      setting :apm_secret_token_encrypted, constructor: Types::Optional::String
      setting :apm_server_ca_cert_file, constructor: Types::Optional::String

      # Simulation Job
      setting :simulator_pool_size, default: 3, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :simulation_job_name, default: 'simulation_job', constructor: Types::Optional::String
      setting :simulation_job_steps, default: 5, constructor: Types::Optional::Coercible::Integer.constrained(gteq: 1)
      setting :simulation_job_max_step_duration, default: 0.1, constructor: Types::Optional::Coercible::Float.constrained(gteq: 0.1)
      setting :simulation_job_error_rate, default: 0.01,
                                          constructor: Types::Optional::Coercible::Float.constrained(gteq: 0.0, lteq: 1.0)
      setting :simulation_job_batch_size, default: 10, constructor: Types::Optional::Coercible::Integer.constrained(gteq: 1)
      setting :simulation_job_batch_wait, default: 20, constructor: Types::Optional::Coercible::Float.constrained(gteq: 0.1)
      setting :simulation_job_iterations, default: 3, constructor: Types::Optional::Coercible::Integer.constrained(gteq: 1)
      # Opt this env out if you want the job to run endlessly.
      setting :simulation_job_max_batches, default: Float::INFINITY,
                                           constructor: Types::Optional::Coercible::Float.constrained(gteq: 1)

      # Ingestion Job
      setting :collector_pool_size, default: 3, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :ingestion_job_name, default: 'ingestion_job', constructor: Types::Optional::String
      setting :ingestion_job_batch_size, default: 20, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :ingestion_job_slice_size, default: 5, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :ingestion_job_batch_wait, default: 20, constructor: Types::Coercible::Float.constrained(gteq: 0.1)
      # Opt this env out if you want the job to run endlessly.
      setting :ingestion_job_max_batches, default: Float::INFINITY,
                                          constructor: Types::Optional::Coercible::Float.constrained(gteq: 1)

      # Generic Job Settings
      setting :sleep_interval, default: 10, constructor: Types::Coercible::Integer.constrained(gteq: 1)
    end
  end
end
