# frozen_string_literal: true

require 'lx/nsx/version'
require 'lx/nsx/cli'

module Lx
  module Nsx
    class Error < StandardError; end

    def self.base_path(rel_path = '')
      @base_path = File.expand_path('../..', __dir__)
      File.join(@base_path, rel_path)
    end
  end
end
