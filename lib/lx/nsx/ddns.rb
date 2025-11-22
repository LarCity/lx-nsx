# frozen_string_literal: true

require 'lar_city/cli/core_cmd'
require 'yaml'

module Lx
  module Nsx
    class Ddns < ::LarCity::CLI::CoreCmd
      desc 'sync', 'Synchronize DDNS records from a YAML configuration file'
      def sync
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
