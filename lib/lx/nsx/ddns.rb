# frozen_string_literal: true

require 'yaml'
require 'thor'

module Lx
  module Nsx
    class Ddns < Thor
      desc 'sync', 'Synchronize DDNS records from a YAML configuration file'
      def sync
        say 'Synchronizing DDNS records...'
      end

      no_commands do
        def config(key: :active, path:)
          YAML.load_file(File.join(path, "#{key}.yml"))
        end
      end
    end
  end
end
