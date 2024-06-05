# frozen_string_literal: true

require_relative '../../lib/garner/types'

module Garner
  App.register_provider(:settings, from: :dry_system) do # rubocop:disable Metrics/BlockLength
    settings do # rubocop:disable Metrics/BlockLength
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
      setting :enable_sql_log, default: false, constructor: Types::Params::Bool.optional

      # Apm
      setting :elastic_apm_service_name, constructor: Types::String.constrained(filled: true)
      setting :elastic_apm_server_url, constructor: Types::String.constrained(filled: true)
      setting :elastic_apm_enabled, default: true, constructor: Types::Params::Bool.constrained(filled: true)
      setting :elastic_apm_secret_token, constructor: Types::Coercible::StringOrNil.optional
      setting :elastic_apm_secret_token_encrypted, constructor: Types::Coercible::StringOrNil.optional
      setting :elastic_apm_server_ca_cert_file, constructor: Types::Coercible::StringOrNil.optional
      setting :elastic_apm_verify_server_cert, default: false, constructor: Types::Params::Bool.optional
      setting :elastic_apm_pool_size, default: 3, constructor: Types::Coercible::Integer.constrained(filled: true)
      setting :elastic_apm_environment, constructor: Types::Coercible::StringOrNil.optional

      # Simulation Job
      setting :simulation_job_enabled, default: false, constructor: Types::Params::Bool.optional
      setting :simulator_pool_size, default: 3, constructor: Types::Coercible::Integer.constrained(gteq: 1).optional
      setting :simulation_job_name, default: 'simulation_job', constructor: Types::String.optional
      setting :simulation_job_steps, default: 5, constructor: Types::Coercible::Integer.constrained(gteq: 1).optional
      setting :simulation_job_max_step_duration, default: 0.1,
                                                 constructor: Types::Coercible::Float.constrained(gteq: 0.1).optional
      setting :simulation_job_error_rate, default: 0.01,
                                          constructor: Types::Coercible::Float.constrained(gteq: 0.0, lteq: 1.0).optional # rubocop:disable Layout/LineLength
      setting :simulation_job_batch_size, default: 10,
                                          constructor: Types::Coercible::Integer.constrained(gteq: 1).optional
      setting :simulation_job_batch_wait, default: 20,
                                          constructor: Types::Coercible::Float.constrained(gteq: 0.1).optional
      setting :simulation_job_iterations, default: 3,
                                          constructor: Types::Coercible::Integer.constrained(gteq: 1).optional
      # Opt this env out if you want the job to run endlessly.
      setting :simulation_job_max_batches, default: Float::INFINITY,
                                           constructor: Types::Optional::Coercible::Float.constrained(gteq: 1).optional

      # Ingestion Job
      setting :ingestion_job_enabled, default: true, constructor: Types::Params::Bool.optional
      setting :collector_pool_size, default: 3, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :ingestion_job_name, default: 'ingestion_job', constructor: Types::String.optional
      setting :ingestion_job_batch_size, default: 20, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :ingestion_job_slice_size, default: 5, constructor: Types::Coercible::Integer.constrained(gteq: 1)
      setting :ingestion_job_batch_wait, default: 20, constructor: Types::Coercible::Float.constrained(gteq: 0.1)
      # Opt this env out if you want the job to run endlessly.
      setting :ingestion_job_max_batches, default: Float::INFINITY,
                                          constructor: Types::Optional::Coercible::Float.constrained(gteq: 1)

      setting :sleep_interval, default: 20,
                               constructor: Types::Optional::Coercible::Float.constrained(gteq: 1)
    end
  end
end
