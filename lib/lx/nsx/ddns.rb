# frozen_string_literal: true

require 'lar_city/cli/core_cmd'
require 'yaml'

module Lx
  module Nsx
    class Ddns < ::LarCity::CLI::CoreCmd
      attr_reader :config_path

      option :config,
             type: :string,
             aliases: '-c',
             default: Lx::Nsx::Utils.base_path('config/ddns'),
             desc: 'Path to DDNS configuration files',
             required: true
      desc 'update', 'Synchronize DDNS records from a YAML configuration file'
      def update
        ap options
        say_debug "Loading DDNS configuration for environment: #{detected_environment}"
        set_config_path options[:config]

        # Load active records from config file
        data = load_config
        ap data if verbose?

        say_info 'Synchronizing DDNS records...'
      end

      no_commands do
        def set_config_path(path)
          @config_path = path
        end

        def load_config(key: :active)
          shared, for_env =
            YAML.load_file(File.join(config_path, "#{key}.yml")).values_at 'shared', detected_environment
          (shared || []) + (for_env || [])
        end
      end
    end
  end
end
