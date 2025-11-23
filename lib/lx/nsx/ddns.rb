# frozen_string_literal: true

require 'lar_city/cli/core_cmd'
require 'yaml'

module Lx
  module Nsx
    class Ddns < ::LarCity::CLI::CoreCmd
      # ::LarCity::CLI::EnvHelpers.define_class_options(self)

      desc 'update', 'Synchronize DDNS records from a YAML configuration file'
      def update
        ap options
        say_debug "Loading DDNS configuration for environment: #{detected_environment}"
        say_info 'Synchronizing DDNS records...'
      end

      no_commands do
        def config(path:, key: :active)
          YAML.load_file(File.join(path, "#{key}.yml"))
        end
      end
    end
  end
end
