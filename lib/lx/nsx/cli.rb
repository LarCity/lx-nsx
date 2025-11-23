# frozen_string_literal: true

require 'dotenv/load'
require 'lx/nsx/ddns'

module Lx
  module Nsx
    class CLI < ::LarCity::CLI::CoreCmd
      desc 'ddns SUBCOMMAND ...ARGS', 'Manage NSX DDNS records'
      subcommand 'ddns', Lx::Nsx::Ddns
    end
  end
end
