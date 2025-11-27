# frozen_string_literal: true

module Lx
  module Ddclient
    class ConfigContext
      attr_accessor :hostname, :login, :password, :protocol, :record_id, :server

      # Aliases for DigitalOcean API
      alias domain_name login
      alias access_token password

      def get_binding
        binding
      end
    end
  end
end
