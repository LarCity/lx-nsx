# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash'
require 'erb'
require 'fileutils'
require 'yaml'

module Lx
  module Nsx
    module Utils
      @config_paths = []

      class << self
        attr_reader :config_paths

        def setup_config_paths
          unless @config_paths.blank?
            puts "Config paths already set up: #{@config_paths.inspect}"
            return
          end

          # @config_paths ||= []
          @config_paths << File.join(Dir.pwd, 'lib', 'config', 'ddns')
          @config_paths << File.join(Dir.home, '.lx', 'nsx', 'config') if Dir.home.present?
        end

        # TODO: Support custom base path via ENV variable
        def base_path(*rel_path)
          @base_path = File.expand_path('../../..', __dir__)
          File.join(@base_path, *rel_path.compact).gsub(%r{/$}, '')
        end

        def spec_path(tmp: false)
          return base_path('spec', 'tmp') if tmp

          base_path('spec')
        end

        def detected_environment
          env = ENV.fetch('RAILS_ENV', nil)
          env || ENV.fetch('RUBY_ENV', 'development')
        end

        def credentials
          # Parse credentials from config/credentials.yml.erb using ERB
          # to allow for environment variable interpolation

          template_file = base_path('config/credentials.yml.erb')
          erb_result = ERB.new(File.read(template_file)).result
          shared, for_env =
            YAML.load(erb_result)&.values_at 'shared', detected_environment
          (shared || {}).merge(for_env || {}).deep_symbolize_keys
        end

        def env_config(path, env: detected_environment, template: false)
          data =
            if template
              erb_result = ERB.new(File.read(path)).result
              YAML.safe_load(erb_result)
            else
              YAML.safe_load_file(path)
            end
          shared, for_env =
            data&.values_at 'shared', env
          (shared || []) + (for_env || [])
        end

        def infer_resource_path(resource_path)
          discovered_path = nil
          config_paths.each do |path|
            candidate_path = File.join(path, resource_path)
            if Dir.exist?(candidate_path) || File.exist?(candidate_path)
              discovered_path = candidate_path
              break
            end
          rescue => e
            puts "Error checking config path #{candidate_path}: #{e.message}"
          end
          raise "Configuration path not found: #{resource_path}" if discovered_path.blank?

          discovered_path
        end

        def included(_base)
          setup_config_paths if @config_paths.blank?
        end
      end
    end
  end
end
