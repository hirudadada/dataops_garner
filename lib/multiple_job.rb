# frozen_string_literal: true

module MultipleJob
  def job_name(name, suffix) = [name, suffix].compact.join('.')

  def modify_config(config, **opts) = config.transform_keys(&:to_sym).merge(opts)

  def build_jobs(klass, config)
    iterations = config.delete(:iterations) || 1

    Array.new(iterations) do |index|
      iteration_name = "iteration-#{index + 1}"
      result = modify_config(config.dup, name: job_name(config[:name], iteration_name))
      klass.new(**result)
    end.compact
  end
end
