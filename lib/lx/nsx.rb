require "lx/nsx/version"
require "lx/nsx/ddns"

module Lx
  module Nsx
    class Error < StandardError; end

    def self.base_path(rel_path = "")
      @base_path = File.expand_path("../../..", __FILE__)
      File.join(@base_path, rel_path)
    end
  end
end
