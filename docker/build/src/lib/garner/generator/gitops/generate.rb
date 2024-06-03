# frozen-string-literal: true

require 'fileutils'
require 'erb'

module Garner
  class Generator
    class GitOpsConfig
      def generate
        generate_gitops_dir
        render_service_configmap
        render_cipher_configmap
        render_credentials_configmap
        render_database_configmap
        render_jobs_configmap
        render_apm_configmap
      end

      protected

      def generate_gitops_dir
        FileUtils.mkdir_p base_dir
        FileUtils.mkdir_p overlays_dir
        FileUtils.mkdir_p dev_jobs_configmap_dir
      end

      def render_service_configmap
        generate_by_template(
          File.join(dev_configmap_dir, 'service.yaml'),
          File.join(configmap_templates_dir, 'service.yaml.erb')
        )
      end

      def render_cipher_configmap
        generate_by_template(
          File.join(base_dir, 'cipher-configmap.yaml'),
          File.join(base_templates_dir, 'cipher-configmap.yaml.erb')
        )
      end

      def render_credentials_configmap
        generate_by_template(
          File.join(dev_configmap_dir, 'credentials.yaml'),
          File.join(configmap_templates_dir, 'credentials.yaml.erb')
        )
      end

      def render_database_configmap
        generate_by_template(
          File.join(dev_configmap_dir, 'database.yaml'),
          File.join(configmap_templates_dir, 'database.yaml.erb')
        )
      end

      def render_apm_configmap
        generate_by_template(
          File.join(dev_configmap_dir, 'apm.yaml'),
          File.join(configmap_templates_dir, 'apm.yaml.erb')
        )
      end

      def render_jobs_configmap
        job_configmap_template = File.join(configmap_templates_dir, 'job.yaml.erb')
        return unless Dir.exist?(jobs_config_dir)

        Dir["#{jobs_config_dir}/*.env"].each do |env_file|
          job_name = File.basename(env_file, '.env')
          job = job_name.gsub('_', '-')
          env_vars = parse_env_file(env_file)
          generate_by_template(
            File.join(dev_jobs_configmap_dir, "#{job_name}.yaml"),
            job_configmap_template,
            binding
          )
        end
      end

      def generate_by_template(output_file, template_file, _binding = binding)
        File.write(
          output_file,
          "#{ERB.new(File.read(template_file), trim_mode: '<>').result(_binding)}\n"
        )
      end

      def parse_env_file(env_file)
        File.readlines(env_file, chomp: true).each_with_object([]) do |line, env_vars|
          name, value = line.split('=')
          next if value.nil?

          value.gsub!(/\$\{([^}]+)\}/) { |match| ENV[::Regexp.last_match(1)] || match }
          env_vars << { name: name, value: value }
        end
      end
    end
  end
end
