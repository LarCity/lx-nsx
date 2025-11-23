# frozen_string_literal: true

require 'fileutils'

module Lx
  module Nsx
    module Utils
      def self.base_path(rel_path = '')
        @base_path = File.expand_path('../..', __dir__)
        File.join(@base_path, rel_path)
      end
    end
  end
end
