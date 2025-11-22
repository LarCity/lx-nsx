# frozen_string_literal: true

require "yaml"

module Lx
  module Nsx
    class Ddns
      class << self
        def sync
          "Synchronizing DDNS records..."
        end

        def config(key: :active, path:)
          YAML.load_file(File.join(path, "#{key}.yml"))
        end
      end
    end
  end
end
