# frozen_string_literal: true

require_relative '../../lib/app/types'

module Garner
  App.register_provider(:settings, from: :dry_system) do # rubocop:disable Metrics/BlockLength
    settings do # rubocop:disable Metrics/BlockLength
      setting :service_name, constructor: Types::Coercible::StringOrNil.optional
      setting :app_name, default: Garnet.app.app_name, constructor: Types::String.constrained(filled: true)
      setting :app_env, default: :production, constructor: Types::Symbol
        .constructor { |value| value.to_s.downcase.to_sym }
        .enum(:development, :test, :production)
      setting :log_level, default: 'info', constructor: Types::String.constrained(filled: true)
      setting :log_formatter, default: 'string', constructor: Types::String.constrained(filled: true)

      # DB
      setting :db_host, constructor: Types::String.constrained(filled: true)
      setting :database_url, constructor: Types::String.constrained(filled: true)
      setting :db_name, constructor: Types::String.constrained(filled: true)
      setting :db_user, constructor: Types::String.constrained(filled: true)
      setting :db_password, constructor: Types::Coercible::StringOrNil.optional
      setting :db_password_encrypted, constructor: Types::Coercible::StringOrNil.optional
      setting :enable_sql_log, constructor: Types::Params::Bool.optional.default(false)

      # Apm
      setting :elastic_apm_server_url, constructor: Types::String.constrained(filled: true)
      setting :elastic_apm_enabled, constructor: Types::Params::Bool.optional.default(true)
      setting :elastic_apm_service_name, constructor: Types::Coercible::String.optional
      setting :elastic_apm_secret_token, constructor: Types::Coercible::StringOrNil.optional
      setting :elastic_apm_secret_token_encrypted, constructor: Types::Coercible::StringOrNil.optional
      setting :elastic_apm_server_ca_cert_file, constructor: Types::Coercible::StringOrNil.optional
      setting :elastic_apm_verify_server_cert, constructor: Types::Params::Bool.optional.default(false)
      setting :elastic_apm_pool_size, constructor: Types::Coercible::StringOrNil.optional

      # Simulation Job
      setting :simulation_job_enabled, constructor: Types::Params::Bool.optional.default(false)
      setting :simulator_pool_size, constructor: Types::Coercible::Integer.constrained(gteq: 1).optional.default(3)
      setting :simulation_job_name, constructor: Types::String.optional.default('simulation_job')
      setting :simulation_job_steps, constructor: Types::Coercible::Integer.constrained(gteq: 1).optional.default(5)
      setting :simulation_job_max_step_duration,
              constructor: Types::Coercible::Float.constrained(gteq: 0.1).optional.default(0.1)
      setting :simulation_job_error_rate,
              constructor: Types::Coercible::Float.constrained(gteq: 0.0, lteq: 1.0).optional.default(0.01)
      setting :simulation_job_batch_size,
              constructor: Types::Coercible::Integer.constrained(gteq: 1).optional.default(10)
      setting :simulation_job_batch_wait,
              constructor: Types::Coercible::Float.constrained(gteq: 0.1).optional.default(20)
      setting :simulation_job_iterations,
              constructor: Types::Coercible::Integer.constrained(gteq: 1).optional.default(3)
      # Opt this env out if you want the job to run endlessly.
      setting :simulation_job_max_batches,
              constructor: Types::Coercible::Float.constrained(gteq: 1).optional.default(Float::INFINITY)

      # Ingestion Job
      setting :ingestion_job_enabled, constructor: Types::Params::Bool.optional.default(true)
      setting :collector_pool_size, constructor: Types::Coercible::Integer.constrained(gteq: 1).default(3)
      setting :ingestion_job_name, constructor: Types::String.optional.default('ingestion_job')
      setting :ingestion_job_batch_size, constructor: Types::Coercible::Integer.constrained(gteq: 1).default(20)
      setting :ingestion_job_slice_size, constructor: Types::Coercible::Integer.constrained(gteq: 1).default(5)
      setting :ingestion_job_batch_wait, constructor: Types::Coercible::Float.constrained(gteq: 0.1).default(20)
      # Opt this env out if you want the job to run endlessly.
      setting :ingestion_job_max_batches,
              constructor: Types::Coercible::Float.constrained(gteq: 1).optional.default(Float::INFINITY)

      setting :sleep_interval,
              constructor: Types::Coercible::Float.constrained(gteq: 1).optional.default(Float::INFINITY)
    end
  end
end
