# frozen_string_literal: true

module Garner
  module ConfigUtils
    class << self
      def format_for_path(env_key)
        sanitize(env_key).gsub('.', '_').downcase
      end

      def format_for_class_name(env_key)
        camel_case(sanitize(str))
      end

      private

      def sanitize(str)
        str.gsub(/[^a-zA-Z0-9\.]/, '').gsub(/\A_+|_+\z/, '')
      end

      def camel_case(str)
        str.split('.').map { |e| e.gsub(/(?:\A|_)([a-z])/) { $1.upcase } }.join
      end
    end
  end
end
