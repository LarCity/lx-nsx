# frozen_string_literal: true

require 'active_support/core_ext/hash'
require 'erb'
require 'fileutils'
require 'yaml'

module Lx
  module Nsx
    module Utils
      # TODO: Support custom base path via ENV variable
      def self.base_path(rel_path = '')
        @base_path = File.expand_path('../../..', __dir__)
        File.join(@base_path, rel_path).gsub(/\/$/, '')
      end

      def self.detected_environment
        env = ENV.fetch('RAILS_ENV', nil)
        env ||= ENV.fetch('RUBY_ENV', 'development')
        env
      end

      def self.credentials
        # Parse credentials from config/credentials.yml.erb using ERB
        # to allow for environment variable interpolation

        template_file = base_path('config/credentials.yml.erb')
        erb_result = ERB.new(File.read(template_file)).result
        shared, for_env =
          YAML.load(erb_result)&.values_at 'shared', detected_environment
        (shared || {}).merge(for_env || {}).deep_symbolize_keys
      end
    end
  end
end
