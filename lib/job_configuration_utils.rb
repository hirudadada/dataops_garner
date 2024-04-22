# frozen_string_literal: true

module JobConfigurationUtils
  def create_config_from_settings(settings, config_prefix)
    settings.select { |k, _| k.start_with?(config_prefix) }
      .transform_keys { |k| k.to_s.sub("#{config_prefix}_", '') }
      .to_h
  end

  def prepare_config(schema, config, name: nil, **kwargs)
    raise ArgumentError, 'job config is not valid' unless schema.call(config).success?

    config.transform_keys!(&:to_sym)
    job_name = name ? "#{config[:name]}.#{name}" : config[:name]
    config = config.merge(kwargs).merge(name: job_name)
  end
end
